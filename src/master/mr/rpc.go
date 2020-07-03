package mr

//
// RPC definitions.
//
// remember to capitalize all names.
//

import "os"
import "strconv"

// Add your RPC definitions here.  完善worker 与master 之间的通讯格式 《1》
const (
	MsgForTask = iota  //ask a task
	MsgForInterFileLoc  //send intermediate files' location to master
	MsgForFinishMap  //finish a map task
	MsgForFinishReduce //finish a reduce task
)

// 下面三段是rpc发送消息的struct和 接受恢复消息的struct 我们把发送消息的struct 分成两类 第一类用来传中间文件的位置给master（MyIntermediateFile）
type MyArgs struct {    //其他消息类型使用MyArgs
	MessageType     int
	MessageCnt      string
}

// send intermediate files' filename to master
type MyIntermediateFile struct {
	MessageType     int
	MessageCnt      string
	NReduceType     int  //其中NReduceType字段是值经过我们自定义的分割函数后，得到了分割后的intermediate 文件交由哪类 reduce 任务的编号。
}

type MyReply struct { //所有RPC请求的reply均使用该类型的reply   struct 中包括： 被分配的任务的类型
	Filename           string         // get a filename（map task）
	MapNumAllocated    int			//map任务被分配的任务编号
	NReduce            int			// sequence number of reduce task
	ReduceNumAllocated int			//reduce任务被分配的任务编号
	TaskType           string		//refer a task type ： "map"or"reduce"
	ReduceFileList     []string       // File list about 字段装载文件名的list
}


// Cook up a unique-ish UNIX-domain socket name
// in /var/tmp, for the master.
// Can't use the current directory since
// Athena AFS doesn't support UNIX-domain sockets.
func masterSock() string {
	s := "/var/tmp/824-mr-"
	s += strconv.Itoa(os.Getuid())
	return s
}