import QtQuick
import qs.Ui

BarWidget {
    id: root
    moduleName: "io.github.enoceli26-oss.biblia-es"
    implicitWidth: button.implicitWidth
    implicitHeight: button.implicitHeight
    readonly property bool opened: reader.item ? reader.item.opened : false
    function open() { if (reader.item) reader.item.open() }
    function close() { if (reader.item) reader.item.close() }
    function closeForPopoutSwitch() { close() }
    function inject() {
        if (!reader.item) return
        reader.item.bar = root.bar
        reader.item.anchorItem = button
        reader.item.hostWidget = root
    }
    onBarChanged: inject()
    Loader {
        id: reader
        source: Qt.resolvedUrl("Reader.qml")
        onLoaded: root.inject()
    }
    WidgetButton {
        id: button
        anchors.fill: parent
        bar: root.bar
        text: root.vertical ? "󰂺" : "󰂺 Biblia"
        tooltipText: "Biblia en español · Reina-Valera 1909"
        onPressed: function(b) {
            if (b === Qt.LeftButton) root.opened ? root.close() : root.open()
        }
    }
}
