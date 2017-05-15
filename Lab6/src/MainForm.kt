import chart.ChartDialog
import dialogs.ValueDialog
import org.apache.commons.io.FilenameUtils
import java.awt.Graphics
import java.awt.GridLayout
import java.awt.Point
import java.awt.event.ActionEvent
import java.awt.event.ActionListener
import java.awt.image.BufferedImage
import java.awt.image.Raster
import java.io.IOException
import javax.imageio.ImageIO
import javax.swing.*

class MainForm : JFrame("") {

    internal var panelImageBefore = ImagePanel()

    internal var linearImageConverter = LinearImageConverter()

    private fun initFileMenu(): JMenuBar {

        val menuBar = JMenuBar()
        val menu = JMenu("Menu")

        val menuOpenFile = JMenuItem("Open File")
        val menuAddConstant = JMenuItem("Add Constant")
        val menuMultiple = JMenuItem("Multiple by Constant")
        val menuDegree = JMenuItem("Degree")
        val menuLogarithm = JMenuItem("Logarithm")
        val menuNegative = JMenuItem("Negative")
        val menuContrast = JMenuItem("Linear Contrast")
        val menuImageChart = JMenuItem("Image Chart")

        menu.add(menuOpenFile)
        menu.add(menuAddConstant)
        menu.add(menuMultiple)
        menu.add(menuDegree)
        menu.add(menuLogarithm)
        menu.add(menuNegative)
        menu.add(menuContrast)
        menu.add(menuImageChart)

        menuBar.add(menu)

        jMenuBar = menuBar

        menuOpenFile.addActionListener(object : StubActionListener(this) {
            override fun actionPerformed(e: ActionEvent) {
                val fileChooser = JFileChooser()
                fileChooser.showOpenDialog(panelImageBefore)
                val chosenFile = fileChooser.selectedFile
                try {
                    val image = ImageIO.read(chosenFile)
                    panelImageBefore.setSize(image.width + 40, image.height + 70)
                    panelImageBefore.setImage(image)
                    linearImageConverter.setImage(image)
                    setSize(image.width + 40, image.height + 130)
                } catch (e1: IOException) {
                    e1.printStackTrace()
                }

            }
        })

        menuAddConstant.addActionListener(object : StubActionListener(this) {
            override fun actionPerformed(e: ActionEvent) {
                val valueDialog = ValueDialog(parentFrame, true)
                valueDialog.setSize(150, 150)
                valueDialog.isVisible = true
                val constant = valueDialog.value.toInt()
                val updatedImage = linearImageConverter.add(constant)
                val dialog = ImageDialog(parentFrame, false, updatedImage)
                dialog.setSize(updatedImage.width + 40, updatedImage.height + 70)
                dialog.isVisible = true
            }
        })

        menuMultiple.addActionListener(object : StubActionListener(this) {
            override fun actionPerformed(e: ActionEvent) {
                val valueDialog = ValueDialog(parentFrame, true)
                valueDialog.setSize(150, 150)
                valueDialog.isVisible = true
                val constant = valueDialog.value
                val updatedImage = linearImageConverter.multiple(constant)
                val dialog = ImageDialog(parentFrame, false, updatedImage)
                dialog.setSize(updatedImage.width + 40, updatedImage.height + 70)
                dialog.isVisible = true
            }
        })

        menuLogarithm.addActionListener(object : StubActionListener(this) {
            override fun actionPerformed(e: ActionEvent) {
                val updatedImage = linearImageConverter.logarithm()
                val dialog = ImageDialog(parentFrame, false, updatedImage)
                dialog.setSize(updatedImage.width + 40, updatedImage.height + 70)
                dialog.isVisible = true
            }
        })

        menuDegree.addActionListener(object : StubActionListener(this) {
            override fun actionPerformed(e: ActionEvent) {
                val valueDialog = ValueDialog(parentFrame, true)
                valueDialog.setSize(150, 150)
                valueDialog.isVisible = true
                val constant = valueDialog.value
                val updatedImage = linearImageConverter.degree(constant)
                val dialog = ImageDialog(parentFrame, false, updatedImage)
                dialog.setSize(updatedImage.width + 40, updatedImage.height + 70)
                dialog.isVisible = true
            }
        })

        menuNegative.addActionListener(object : StubActionListener(this) {
            override fun actionPerformed(e: ActionEvent) {
                val updatedImage = linearImageConverter.makeNegative()
                val dialog = ImageDialog(parentFrame, false, updatedImage)
                dialog.setSize(updatedImage.width + 40, updatedImage.height + 70)
                dialog.isVisible = true
            }
        })

        menuContrast.addActionListener(object : StubActionListener(this) {
            override fun actionPerformed(e: ActionEvent) {
                val updatedImage = linearImageConverter.contrast()
                val dialog = ImageDialog(parentFrame, false, updatedImage)
                dialog.setSize(updatedImage.width + 40, updatedImage.height + 70)
                dialog.isVisible = true
            }
        })

        menuImageChart.addActionListener(object : StubActionListener(this) {
            override fun actionPerformed(e: ActionEvent) {
                val dialog = ChartDialog(parentFrame, false, linearImageConverter.getImage())
                dialog.setSize(500, 500)
                dialog.isVisible = true
            }
        })

        return menuBar
    }

    init {
        defaultCloseOperation = JFrame.EXIT_ON_CLOSE


        panelImageBefore.setSize(this.width, 0)
        panelImageBefore.layout = GridLayout(0, 1)

        this.layout = GridLayout(1, 1)
        this.add(panelImageBefore)

        setSize(500, 500)

        this.jMenuBar = initFileMenu()
    }

    class ImageDialog(owner: JFrame, modal: Boolean, val image: BufferedImage) : JDialog(owner, modal) {
        internal var imagePanel = ImagePanel()

        private fun initFileMenu(): JMenuBar {
            val menuBar = JMenuBar()
            val menuSaveFile = JButton("Save File")
            menuBar.add(menuSaveFile)

            menuSaveFile.addActionListener {
                val fileChooser = JFileChooser()
                fileChooser.showSaveDialog(imagePanel)
                val updatedFile = fileChooser.selectedFile
                try {
                    ImageIO.write(image,
                            FilenameUtils.getExtension(updatedFile.absolutePath),
                            updatedFile
                    )
                } catch (e1: IOException) {
                    e1.printStackTrace()
                }
            }

            return menuBar
        }

        init {
            val imagePanel = ImagePanel()
            imagePanel.setImage(image)
            jMenuBar = initFileMenu()
            add(imagePanel)
        }
    }
}

open class ImagePanel : JPanel() {

    private var image: BufferedImage? = null

    fun setImage(image: BufferedImage) {
        this.image = image
    }

    override fun paintComponent(g: Graphics) {
        super.paintComponent(g)
        if (image != null) {
            g.drawImage(image, 0, 0, null)
        }
    }

}

class LinearImageConverter {

    private lateinit var image: BufferedImage
    private var maxGray: Int = 0
    private var minGray: Int = 0

    constructor() {}

    constructor(input: BufferedImage) {
        this.image = input
        findMaxGray()
        findMinGray()
    }

    fun add(x: Int): BufferedImage {
        val result = copyImage(image)
        val data = result.data.dataBuffer
        for (i in 0..data.size - 1) {
            var gray = data.getElem(i)
            gray += x
            if (gray > 255) gray = 255
            if (gray < 0) gray = 0
            data.setElem(i, gray)
        }
        result.data = Raster.createRaster(result.data.sampleModel, data, Point(0, 0))
        return result
    }

    fun multiple(x: Double): BufferedImage {
        val result = copyImage(image)
        val data = result.data.dataBuffer
        for (i in 0..data.size - 1) {
            var gray = data.getElem(i)
            gray *= x.toInt()
            if (gray > 255) gray = 255
            if (gray < 0) gray = 0
            data.setElem(i, gray)
        }
        result.data = Raster.createRaster(result.data.sampleModel, data, Point(0, 0))
        return result
    }

    fun degree(x: Double): BufferedImage {
        val result = copyImage(image)
        val data = result.data.dataBuffer
        for (i in 0..data.size - 1) {
            var gray = data.getElem(i)
            gray = (255 * Math.pow(gray * 1.0 / maxGray * 1.0, x)).toInt()
            if (gray > 255) gray = 255
            if (gray < 0) gray = 0
            data.setElem(i, gray)
        }
        result.data = Raster.createRaster(result.data.sampleModel, data, Point(0, 0))
        return result
    }

    fun logarithm(): BufferedImage {
        val result = copyImage(image)
        val data = result.data.dataBuffer
        for (i in 0..data.size - 1) {
            var gray = data.getElem(i)
            gray = (255 * (Math.log((1 + gray).toDouble()) / Math.log((1 + maxGray).toDouble()))).toInt()
            if (gray > 255) gray = 255
            if (gray < 0) gray = 0
            data.setElem(i, gray)
        }
        result.data = Raster.createRaster(result.data.sampleModel, data, Point(0, 0))
        return result
    }

    fun makeNegative(): BufferedImage {
        val result = copyImage(image)
        val data = result.data.dataBuffer
        for (i in 0..data.size - 1) {
            var gray = data.getElem(i)
            gray = 255 - gray
            data.setElem(i, gray)
        }
        result.data = Raster.createRaster(result.data.sampleModel, data, Point(0, 0))
        return result
    }

    fun contrast(): BufferedImage {
        val result = copyImage(image)
        val data = result.data.dataBuffer
        for (i in 0..data.size - 1) {
            var gray = data.getElem(i)
            gray = 255 / (maxGray - minGray) * (gray - minGray)
            data.setElem(i, gray)
        }
        result.data = Raster.createRaster(result.data.sampleModel, data, Point(0, 0))
        return result
    }

    private fun copyImage(bi: BufferedImage): BufferedImage {
        val cm = bi.colorModel
        val isAlphaPremultiplied = cm.isAlphaPremultiplied
        val raster = bi.copyData(null)
        return BufferedImage(cm, raster, isAlphaPremultiplied, null)
    }

    fun setImage(image: BufferedImage) {
        this.image = image
        findMaxGray()
        findMinGray()
    }

    private fun findMinGray() {
        val data = image!!.data.dataBuffer
        minGray = data.getElem(0)
        for (i in 0..data.size - 1) {
            if (data.getElem(i) < minGray)
                minGray = data.getElem(i)
        }
    }

    private fun findMaxGray() {
        val data = image!!.data.dataBuffer
        maxGray = 0
        for (i in 0..data.size - 1) {
            if (data.getElem(i) > maxGray)
                maxGray = data.getElem(i)
        }
    }

    fun getImage(): BufferedImage {
        return image
    }
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

fun main(args: Array<String>) {
    var app: MainForm? = null
    try {
        app = MainForm()
    } catch (e: IOException) {
        e.printStackTrace()
    }

    app!!.isVisible = true
}