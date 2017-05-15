import org.jfree.ui.tabbedui.VerticalLayout

import javax.swing.*
import java.awt.*

fun main(args: Array<String>) {
    Main().solve(args)
}

class Main {
    private var currentType = TYPE.BRES

    private enum class TYPE private constructor(var value: String?) {
        BRES("Bresenham"),
        BRES_CIRCLE("Bresenham Circle"),
        CDA("CDA"),
        SIMPLE("Simple")
    }

    internal var x0textField = JTextField()
    internal var y0textField = JTextField()
    internal var x1textField = JTextField()
    internal var y1textField = JTextField()
    internal var label = JLabel(TYPE.BRES.value)
    internal var button = JButton()

    fun solve(args: Array<String>) {

        val mainFrame = JFrame()
        mainFrame.isVisible = true
        mainFrame.defaultCloseOperation = WindowConstants.EXIT_ON_CLOSE
        mainFrame.preferredSize = Dimension(500, 500)
        mainFrame.size = Dimension(500, 500)
        mainFrame.setLocation(400, 150)

        val menuBar = JMenuBar()

        val jMenuType = JMenu("Types")
        val jMenuItemBresenham = JMenuItem("Bresenham")
        val jMenuItemCircle = JMenuItem("Bresenham circle")
        val jMenuItemCDA = JMenuItem("CDA")
        val jMenuItemSimple = JMenuItem("Simple")

        jMenuType.add(jMenuItemBresenham)
        jMenuType.add(jMenuItemCircle)
        jMenuType.add(jMenuItemCDA)
        jMenuType.add(jMenuItemSimple)

        jMenuItemBresenham.addActionListener { e ->
            currentType = TYPE.BRES
            label.text = TYPE.BRES.value
            mainFrame.contentPane.remove(0)
            mainFrame.contentPane.add(panel)
            mainFrame.repaint()
            mainFrame.pack()
        }

        jMenuItemCDA.addActionListener { e ->
            currentType = TYPE.CDA
            label.text = TYPE.CDA.value
            mainFrame.contentPane.remove(0)
            mainFrame.contentPane.add(panel)
            mainFrame.repaint()
            mainFrame.pack()
        }

        jMenuItemSimple.addActionListener { e ->
            currentType = TYPE.SIMPLE
            label.text = TYPE.SIMPLE.value
            mainFrame.contentPane.remove(0)
            mainFrame.contentPane.add(panel)
            mainFrame.repaint()
            mainFrame.pack()
        }

        jMenuItemCircle.addActionListener { e ->
            currentType = TYPE.BRES_CIRCLE
            label.text = TYPE.BRES_CIRCLE.value
            mainFrame.contentPane.remove(0)
            mainFrame.contentPane.add(panel)
            mainFrame.repaint()
            mainFrame.pack()
        }

        menuBar.add(jMenuType)
        mainFrame.jMenuBar = menuBar
        mainFrame.contentPane.add(panel, 0)
        mainFrame.pack()

        button.text = "GO!"
        button.addActionListener { e ->
            try {
                var algorithm = JFrame()
                when (currentType) {
                    Main.TYPE.BRES -> algorithm = BresenhamAlgorithm("Bresenham algorithm",
                            Integer.parseInt(x0textField.text),
                            Integer.parseInt(y0textField.text),
                            Integer.parseInt(x1textField.text),
                            Integer.parseInt(y1textField.text))
                    Main.TYPE.BRES_CIRCLE -> algorithm = BresenhamCircleAlgorithm("Bresenham sirce algorithm",
                            Integer.parseInt(x0textField.text),
                            Integer.parseInt(y0textField.text),
                            Integer.parseInt(x1textField.text))
                    Main.TYPE.CDA -> algorithm = CDAAlgorithm("CDA algorithm",
                            Integer.parseInt(x0textField.text),
                            Integer.parseInt(y0textField.text),
                            Integer.parseInt(x1textField.text),
                            Integer.parseInt(y1textField.text))
                    Main.TYPE.SIMPLE -> algorithm = SimpleStepAlgorithm("Simple step algorithm",
                            Integer.parseInt(x0textField.text),
                            Integer.parseInt(y0textField.text),
                            Integer.parseInt(x1textField.text),
                            Integer.parseInt(y1textField.text))
                }
                algorithm.pack()
                algorithm.isVisible = true
            } catch (exp: NumberFormatException) {
                JOptionPane.showMessageDialog(mainFrame, "Fill all coordinates.")
            }
        }
    }

    private val panel: JPanel
        get() {
            val panel = JPanel()
            panel.layout = VerticalLayout()

            val x0 = JLabel("x0")
            var text = x0textField.text
            x0textField = JTextField(text)
            val y0 = JLabel("y0")
            text = y0textField.text
            y0textField = JTextField(text)
            panel.add(label)

            panel.add(x0)
            panel.add(x0textField)
            panel.add(y0)
            panel.add(y0textField)

            if (currentType == TYPE.BRES_CIRCLE) {
                val x1 = JLabel("R")
                text = x1textField.text
                x1textField = JTextField(text)
                panel.add(x1)
                panel.add(x1textField)
            } else {
                val x1 = JLabel("x1")
                text = x1textField.text
                x1textField = JTextField(text)
                val y1 = JLabel("y1")
                text = y1textField.text
                y1textField = JTextField(text)
                panel.add(x1)
                panel.add(x1textField)
                panel.add(y1)
                panel.add(y1textField)
            }

            panel.add(button)
            return panel
        }
}
