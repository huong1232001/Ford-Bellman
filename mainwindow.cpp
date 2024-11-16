#include "mainwindow.h"
#include <QQuickView>
#include <QQmlContext>
#include <QVBoxLayout>
#include <QWidget>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    // Khởi tạo QQuickView để load QML
    QQuickView *mapView = new QQuickView();

    // Thiết lập QML nguồn
    mapView->setSource(QUrl(QStringLiteral("qrc:/new/prefix1/MapView.qml")));

    // Tạo một QWidget để chứa QQuickView
    QWidget *container = QWidget::createWindowContainer(mapView);

    // Đặt container làm khu vực trung tâm
    setCentralWidget(container);

    // Bạn có thể truy cập các đối tượng QML từ C++ bằng cách sử dụng context
    auto *context = mapView->rootContext();

    // Thêm các biến từ C++ vào QML, nếu cần
    context->setContextProperty("mainWindow", this);
}

// Định nghĩa hàm hủy
MainWindow::~MainWindow() {
    delete ui;
}
