package main
import(
	"../mr"

)
import "unicode"
import "strings"
import "strconv"

func Map(filename string, contents string) []mr.KeyValue {
	// function to detect word separators.

	ff := func(r rune) bool { return !unicode.IsLetter(r) }
	// split contents into an array of words.
	words := strings.FieldsFunc(contents, ff)

	kva := []mr.KeyValue{}
	for _, w := range words {
		kv := mr.KeyValue{w, "1"}
		if (strings.EqualFold(kv.Key, "it")){
			kva = append(kva,kv)
		}
	}

	return kva
}

func Reduce(key string, values []string) string {
	// return the number of occurrences of this word.
	return strconv.Itoa(len(values))

}