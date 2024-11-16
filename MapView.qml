import QtQuick 2.15
import QtLocation 6.8
import QtPositioning 6.8

Rectangle {
    anchors.fill: parent

    Map {
        id: map
        anchors.fill: parent
        plugin: Plugin {
            name: "osm"  // Sử dụng OpenStreetMap
            PluginParameter { name: "osm.mapping.providersrepository.disabled"; value: true }
        }
        center: QtPositioning.coordinate(10.8231, 106.6297) // Tọa độ TP. Hồ Chí Minh
        zoomLevel: 15  // Mức độ zoom ban đầu

        // Marker (dấu hiệu)
        MapQuickItem {
            id: marker
            visible: false // Ẩn marker khi bắt đầu
            coordinate: QtPositioning.coordinate(10.8231, 106.6297)  // Vị trí mặc định (TP. Hồ Chí Minh)
            sourceItem: Rectangle {
                width: 20
                height: 20
                color: "pink"
                border.color: "black"
                border.width: 1
            }
        }

        // Xử lý sự kiện click chuột trên bản đồ
        MouseArea {
            anchors.fill: parent
            onClicked: {
                marker.coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y)); // Lấy tọa độ nơi click trên bản đồ
                marker.visible = true; // Hiển thị marker sau khi click

                map.center = marker.coordinate; // Phóng to bản đồ tại vị trí click

                // Gửi yêu cầu geocoding để chuyển tọa độ thành địa chỉ
                geocodeCoordinate(marker.coordinate);
            }
        }
    }

    // Container cho các nút Zoom
    Column {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        spacing: 10

        // Nút thu nhỏ (Zoom Out)
        Rectangle {
            width: 50
            height: 50
            color: "pink"
            radius: 25
            border.color: "black"

            Text {
                anchors.centerIn: parent
                text: "−"
                color: "white"
                font.pixelSize: 24
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Giảm mức zoom
                    if (map.zoomLevel > 1) {
                        map.zoomLevel -= 1;
                    }
                }
            }
        }

        // Nút phóng to (Zoom In)
        Rectangle {
            width: 50
            height: 50
            color: "pink"
            radius: 25
            border.color: "black"

            Text {
                anchors.centerIn: parent
                text: "+"
                color: "white"
                font.pixelSize: 24
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    // Tăng mức zoom
                    if (map.zoomLevel < 19) {
                        map.zoomLevel += 1;
                    }
                }
            }
        }
    }

    Item {
        width: parent.width - 800  // Đảm bảo độ rộng vừa với màn hình
        height: 50

        // Nền của TextEdit với màu hồng nhạt
        Rectangle {
            anchors.fill: parent
            color: "pink"  // Màu hồng nhạt
            radius: 15
            border.color: "black"
            border.width: 1
        }

        // TextEdit nằm trên nền
        TextEdit {
            id: locationTextBox
            width: parent.width  // Đảm bảo TextEdit không tràn ra ngoài Item
            height: parent.height  // Đảm bảo TextEdit phủ đầy chiều cao của Item
            font.pixelSize: 18  // Kích thước chữ
            text: ""  // Ban đầu để trống để hiển thị giả placeholder
            cursorVisible: true  // Hiển thị con trỏ khi ô nhập được chọn
            focus: true  // Cho phép nhập liệu
            horizontalAlignment: TextEdit.AlignLeft  // Căn trái để văn bản được hiển thị từ trái sang phải
            verticalAlignment: Text.AlignVCenter  // Căn giữa theo chiều dọc
            padding: 10  // Đẩy text xuống dưới một chút

            wrapMode: TextEdit.NoWrap  // Không tự động xuống dòng
        }
    }

    // Nút Tìm kiếm
    Rectangle {
        width: 100
        height: 50
        color: "pink"
        radius: 10
        border.color: "black"
        anchors.top: parent.top  // Đặt nút lên phía trên
        anchors.left: parent.left
        anchors.margins: 490
        anchors.topMargin: 0 // Thêm khoảng cách từ trên xuống

        Text {
            anchors.centerIn: parent
            text: "Tìm kiếm"
            color: "black"
            font.pixelSize: 18
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Cập nhật vị trí tìm kiếm (có thể thay thế bằng API geocoding thực tế)
                var searchCoordinates = QtPositioning.coordinate(10.8231, 106.6297); // Ví dụ với tọa độ cố định
                marker.coordinate = searchCoordinates;
                marker.visible = true;
                map.center = searchCoordinates; // Di chuyển bản đồ đến vị trí tìm kiếm
                locationTextBox.text = "Vị trí: " + searchCoordinates.latitude + ", " + searchCoordinates.longitude; // Cập nhật thông tin vị trí
            }
        }
    }

    // Hàm Geocoding
    function geocodeCoordinate(coordinate) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "https://nominatim.openstreetmap.org/reverse?lat=" + coordinate.latitude + "&lon=" + coordinate.longitude + "&format=json", true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    if (response.address) {
                        locationTextBox.text = "Vị trí: " + response.address.road + ", " + response.address.city + ", " + response.address.country;
                    } else {
                        locationTextBox.text = "Không tìm thấy địa chỉ!";
                    }
                }
            }
        };
        xhr.send();
    }
}
