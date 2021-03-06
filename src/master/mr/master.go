package mr

import "log"
import "net"
//import "os"
import "net/rpc"
import "net/http"
import "strconv"
import "sync"
import "time"


// tasks' status
const (
	UnAllocated = iota  //unmaped
	Allocated			//map to a worker
	Finished			//worker finish the map task
)

var maptasks chan string          // chan for map task
var reducetasks chan int          // chan for reduce task

// Master struct 完善master结构体和MyCallHandler《2》
type Master struct {  // 消息中包括中间值的存放位置这也是worker 发给master的，所以需要在master中对这些位置做记录。
	// Your definitions here.
	AllFilesName        map[string]int	//8pg*.txt files: the input
	MapTaskNumCount     int				//sequence number of map tasks
	NReduce             int               // sequence number of reduce task
	InterFIlename       [][]string        // intermediate file
	MapFinished         bool			//true if all done
	ReduceTaskStatus    map[int]int      // about reduce tasks' status
	ReduceFinished      bool              // true if Finish the reduce task
	RWLock              *sync.RWMutex
}

// MyCallHandler func《4》
// Your code here -- RPC handlers for the worker to call.
//master 里判断 args里的消息类型。 如果是 MsgForTask 的话，就向 worker 传一个 task。该 task 也是由 master 生产的。很明显，在map执行完之前，reduce任务是不会执行的。这个从我们之前的代码 generateTask 中可以看出。
//如果消息类型是 MsgForFinishMap 或 MsgForFinishReduce 的话，将对应的 task 的状态设置为 Finished。
//如果消息类型是 MsgForInterFileLoc 的话， 我们这里另外写一个函数，供 worker 调用，处理该消息类型：（往下看MyInnerFileHandler）
func (m *Master) MyCallHandler(args *MyArgs, reply *MyReply) error {
	msgType := args.MessageType
	switch(msgType) {
	case MsgForTask:
		select {
		case filename := <- maptasks:
			// allocate map task
			reply.Filename = filename
			reply.MapNumAllocated = m.MapTaskNumCount
			reply.NReduce = m.NReduce
			reply.TaskType = "map"

			m.RWLock.Lock()
			m.AllFilesName[filename] = Allocated
			m.MapTaskNumCount++
			m.RWLock.Unlock()
			go m.timerForWorker("map",filename)
			return nil

		case reduceNum := <- reducetasks:
			// allocate reduce task
			reply.TaskType = "reduce"
			reply.ReduceFileList = m.InterFIlename[reduceNum]
			reply.NReduce = m.NReduce
			reply.ReduceNumAllocated = reduceNum

			m.RWLock.Lock()
			m.ReduceTaskStatus[reduceNum] = Allocated
			m.RWLock.Unlock()
			go m.timerForWorker("reduce", strconv.Itoa(reduceNum))
			return nil
		}
	case MsgForFinishMap:
		m.RWLock.Lock()
		defer m.RWLock.Unlock()
		m.AllFilesName[args.MessageCnt] = Finished   // set status as finish
	case MsgForFinishReduce:
		index, _ := strconv.Atoi(args.MessageCnt)
		m.RWLock.Lock()
		defer m.RWLock.Unlock()
		m.ReduceTaskStatus[index] = Finished	//set status as finish
	}
	return nil
}

// timerForWorker : monitor the worker
func (m *Master)timerForWorker(taskType, identify string) {
	ticker := time.NewTicker(100 * time.Second)
	defer ticker.Stop()
	for {
		select {
		case <-ticker.C:
			if taskType == "map" {
				m.RWLock.Lock()
				m.AllFilesName[identify] = UnAllocated
				m.RWLock.Unlock()
				maptasks <- identify
			} else if taskType == "reduce" {
				index, _ := strconv.Atoi(identify)
				m.RWLock.Lock()
				m.ReduceTaskStatus[index] = UnAllocated
				m.RWLock.Unlock()
				reducetasks <- index
			}
			return
		default:
			if taskType == "map" {
				m.RWLock.RLock()
				if m.AllFilesName[identify] == Finished {
					m.RWLock.RUnlock()
					return
				} else {
					m.RWLock.RUnlock()
				}
			} else if taskType == "reduce" {
				index, _ := strconv.Atoi(identify)
				m.RWLock.RLock()
				if m.ReduceTaskStatus[index] == Finished {
					m.RWLock.RUnlock()
					return
				} else {
					m.RWLock.RUnlock()
				}
			}
		}
	}
}



// MyInnerFileHandler : intermediate files' handler 如果消息类型是 MsgForInterFileLoc 的话， 我们这里另外写一个函数，供 worker 调用，处理该消息类型
func (m *Master) MyInnerFileHandler(args *MyIntermediateFile, reply *MyReply) error {
	nReduceNUm := args.NReduceType; //通过读取nReduceNUm字段获取该文件应由哪个编号的reduce任务处理， 存放在相应的位置
	filename := args.MessageCnt;

	m.InterFIlename[nReduceNUm] = append(m.InterFIlename[nReduceNUm], filename)
	return nil
}



//
// start a thread that listens for RPCs from worker.go
//
func (m *Master) server() { //在makemaster 中初始化《3》
	maptasks = make(chan string, 5)
	reducetasks = make(chan int, 5)
	rpc.Register(m)
	rpc.HandleHTTP()
	go m.generateTask()
	l, e := net.Listen("tcp", ":4000")
	//sockname := masterSock()
	//os.Remove(sockname)
	//l, e := net.Listen("unix", sockname)
	if e != nil {
		log.Fatal("listen error:", e)
	}
	go http.Serve(l, nil)
}

// GenerateTask : create tasks
func (m *Master) generateTask() {
	for k,v := range m.AllFilesName {
		if v == UnAllocated {
			maptasks <- k
		}
	}
	ok := false
	for !ok {
		ok = checkAllMapTask(m)
	}

	m.MapFinished = true

	for k,v := range m.ReduceTaskStatus {
		if v == UnAllocated {
			reducetasks <- k
		}
	}

	ok = false
	for !ok {
		ok = checkAllReduceTask(m)
	}
	m.ReduceFinished = true
}

// checkAllMapTask : check if all map tasks are finished
func checkAllMapTask(m *Master) bool {
	m.RWLock.RLock()
	defer m.RWLock.RUnlock()
	for _,v := range m.AllFilesName {
		if v != Finished {
			return false
		}
	}
	return true
}

func checkAllReduceTask(m *Master) bool {
	m.RWLock.RLock()
	defer m.RWLock.RUnlock()
	for _, v := range m.ReduceTaskStatus {
		if v != Finished {
			return false
		}
	}
	return true
}

//
// main/mrmaster.go calls Done() periodically to find out
// if the entire job has finished.
//
func (m *Master) Done() bool {
	ret := false
	// Your code here.
	ret = m.ReduceFinished

	return ret
}

//
// create a Master.
// main/mrmaster.go calls this function.
//
func MakeMaster(files []string, nReduce int) *Master {
	m := Master{}
	m.AllFilesName = make(map[string]int)
	m.MapTaskNumCount = 0
	m.NReduce = nReduce
	m.MapFinished = false
	m.ReduceFinished = false
	m.ReduceTaskStatus = make(map[int]int)
	m.InterFIlename = make([][]string, m.NReduce)
	m.RWLock = new(sync.RWMutex)
	for _,v := range files {
		m.AllFilesName[v] = UnAllocated
	}

	for i := 0; i<nReduce; i++ {
		m.ReduceTaskStatus[i] = UnAllocated
	}

	m.server()
	return &m
}
