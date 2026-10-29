pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons as Commons
import qs.Ui

Panel {
    id: root
    moduleName: "io.github.enoceli26-oss.biblia-es"
    manageIpc: false
    property var anchorItem: null
    property var hostWidget: null
    property var books: []
    property var results: []
    property string errorMessage: ""
    property int bookIndex: 0
    property int chapterIndex: 0
    property int readingSize: 18
    property bool searching: false
    readonly property var book: books.length ? books[bookIndex] : null
    readonly property var verses: book ? book.chapters[chapterIndex] : []
    readonly property color ink: Commons.Color.popups.text

    function navigate(b, c) {
        bookIndex = b
        chapterIndex = c
        searching = false
        search.text = ""
        scroll.contentY = 0
    }
    function move(delta) {
        var b = bookIndex, c = chapterIndex + delta
        if (c < 0) { if (b === 0) return; b--; c = books[b].chapters.length - 1 }
        if (c >= books[b].chapters.length) { if (b === books.length - 1) return; b++; c = 0 }
        navigate(b, c)
    }
    function normalize(s) { return s.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "") }
    function find() {
        var q = normalize(search.text.trim()), matches = []
        if (q.length < 3) { searching = false; return }
        for (var b = 0; b < books.length; b++) {
            for (var c = 0; c < books[b].chapters.length; c++) {
                var chapter = books[b].chapters[c]
                for (var v = 0; v < chapter.length; v++) {
                    if (normalize(chapter[v]).indexOf(q) !== -1) {
                        matches.push({b:b, c:c, v:v, text:chapter[v]})
                        if (matches.length >= 200) break
                    }
                }
                if (matches.length >= 200) break
            }
            if (matches.length >= 200) break
        }
        results = matches
        searching = true
        scroll.contentY = 0
    }
    function daily() {
        if (!books.length) return
        var now = new Date()
        var day = Math.floor(Date.UTC(now.getFullYear(), now.getMonth(), now.getDate()) / 86400000)
        var total = 0
        for (var b = 0; b < books.length; b++)
            for (var c = 0; c < books[b].chapters.length; c++) total += books[b].chapters[c].length
        var n = day % total
        for (b = 0; b < books.length; b++) {
            for (c = 0; c < books[b].chapters.length; c++) {
                var ch = books[b].chapters[c]
                if (n < ch.length) {
                    results = [{b:b,c:c,v:n,text:ch[n]}]
                    searching = true
                    search.text = ""
                    scroll.contentY = 0
                    return
                }
                n -= ch.length
            }
        }
    }
    FileView {
        path: Qt.resolvedUrl("data/biblia.json").toString().replace("file://", "")
        onLoaded: {
            try {
                root.books = JSON.parse(text().replace(/^\uFEFF/, ""))
                root.errorMessage = ""
            } catch (e) { root.errorMessage = "No se pudo leer la Biblia: " + e }
        }
        onLoadFailed: root.errorMessage = "No se pudo abrir el texto bíblico local."
    }
    KeyboardPanel {
        id: popup
        anchorItem: root.anchorItem
        owner: root.hostWidget || root
        bar: root.bar
        open: root.opened
        contentWidth: popup.fittedContentWidth(640)
        contentHeight: popup.fittedContentHeight(700)
        focusTarget: search
        ColumnLayout {
            anchors.fill: parent
            spacing: 10
            Keys.onEscapePressed: root.close()
            RowLayout {
                Layout.fillWidth: true
                Text { text: "Biblia en español"; color: root.ink; font.pixelSize: 24; font.bold: true; Layout.fillWidth: true }
                Controls.Button { text: "A−"; enabled: root.readingSize > 14; onClicked: root.readingSize -= 2 }
                Controls.Button { text: "A+"; enabled: root.readingSize < 30; onClicked: root.readingSize += 2 }
                Controls.Button { text: "Cerrar"; onClicked: root.close() }
            }
            Text { text: "Reina-Valera 1909 · Sin conexión"; color: root.ink; opacity: 0.65 }
            RowLayout {
                Controls.ComboBox {
                    Layout.fillWidth: true
                    model: root.books.map(function(b) { return b.name })
                    currentIndex: root.bookIndex
                    onActivated: function(i) { root.navigate(i, 0) }
                    enabled: root.books.length > 0
                }
                Controls.ComboBox {
                    model: root.book ? Array.from({length: root.book.chapters.length}, function(_, i) { return "Capítulo " + (i+1) }) : []
                    currentIndex: root.chapterIndex
                    onActivated: function(i) { root.navigate(root.bookIndex, i) }
                }
            }
            RowLayout {
                Controls.TextField {
                    id: search
                    Layout.fillWidth: true
                    placeholderText: "Buscar palabras en toda la Biblia…"
                    onAccepted: root.find()
                    selectByMouse: true
                }
                Controls.Button { text: "Buscar"; enabled: search.text.trim().length >= 3; onClicked: root.find() }
            }
            RowLayout {
                Controls.Button { text: "← Anterior"; enabled: root.books.length > 0; onClicked: root.move(-1) }
                Controls.Button { text: "Versículo del día"; enabled: root.books.length > 0; onClicked: root.daily() }
                Controls.Button { text: "Siguiente →"; enabled: root.books.length > 0; onClicked: root.move(1) }
            }
            Text {
                Layout.fillWidth: true
                color: root.ink
                wrapMode: Text.Wrap
                text: root.errorMessage || (!root.books.length ? "Cargando…" : root.searching ? (search.text ? "Resultados: " + root.results.length + (root.results.length === 200 ? " (límite de 200)" : "") : "Versículo del día") : root.book.name + " " + (root.chapterIndex + 1))
                font.bold: true
            }
            Flickable {
                id: scroll
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                contentWidth: width
                contentHeight: rows.implicitHeight
                boundsBehavior: Flickable.StopAtBounds
                Controls.ScrollBar.vertical: Controls.ScrollBar {}
                Column {
                    id: rows
                    width: scroll.width - 16
                    spacing: 14
                    Repeater {
                        model: root.searching ? root.results : root.verses
                        delegate: Column {
                            id: row
                            required property var modelData
                            required property int index
                            width: rows.width
                            spacing: 4
                            Text {
                                visible: root.searching
                                text: root.searching ? root.books[row.modelData.b].name + " " + (row.modelData.c+1) + ":" + (row.modelData.v+1) : ""
                                color: Commons.Color.accent
                                font.bold: true
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.navigate(row.modelData.b, row.modelData.c) }
                            }
                            TextEdit {
                                width: parent.width
                                readOnly: true
                                selectByMouse: true
                                wrapMode: TextEdit.Wrap
                                textFormat: TextEdit.PlainText
                                color: root.ink
                                font.pixelSize: root.readingSize
                                text: root.searching ? row.modelData.text : (row.index+1) + "  " + row.modelData
                            }
                        }
                    }
                }
            }
            Text { text: "Selecciona texto para copiar con Ctrl+C · Esc para cerrar"; color: root.ink; opacity: 0.6; font.pixelSize: 12 }
        }
    }
}
