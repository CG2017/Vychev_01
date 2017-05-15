package dialogs

import javax.swing.*
import java.awt.*
import java.awt.event.ActionEvent
import java.awt.event.ActionListener
import java.awt.event.WindowEvent

class ValueDialog(owner: Frame, modal: Boolean) : JDialog(owner, modal) {

    var value: Double = 0.toDouble()
        private set

    init {
        val panel = JPanel()
        val valueTextField = JTextField()
        val submit = JButton("OK")

        panel.setSize(this.width, this.height)
        panel.layout = GridLayout(0, 1)

        submit.addActionListener(object : StubActionListener(this) {
            override fun actionPerformed(e: ActionEvent) {
                try {
                    value = java.lang.Double.parseDouble(valueTextField.text)
                    dialog.dispatchEvent(WindowEvent(dialog, WindowEvent.WINDOW_CLOSING))
                } catch (ex: Exception) {

                }

            }
        })
        panel.add(valueTextField)
        panel.add(submit)
        add(panel)
    }

    open class StubActionListener : ActionListener {
        lateinit var parentFrame: JFrame
        lateinit var dialog: JDialog

        constructor(dialog: JDialog) {
            this.dialog = dialog
        }

        constructor(parentFrame: JFrame) {
            this.parentFrame = parentFrame
        }

        override fun actionPerformed(e: ActionEvent) {

        }
    }
}
