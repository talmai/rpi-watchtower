package mockclient

import (
	"reflect"
	"testing"

	"github.com/talmai/rpi-watchtower/container"
)

func TestMockInterface(t *testing.T) {
	iface := reflect.TypeOf((*container.Client)(nil)).Elem()
	mock := &MockClient{}

	if !reflect.TypeOf(mock).Implements(iface) {
		t.Fatalf("Mock does not implement the Client interface")
	}
}
