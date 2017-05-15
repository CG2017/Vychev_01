package chart

import dialogs.ValueDialog
import org.jfree.chart.ChartFactory
import org.jfree.chart.ChartPanel
import org.jfree.chart.plot.PlotOrientation
import org.jfree.data.xy.DefaultXYDataset
import java.awt.GridLayout
import java.awt.event.ActionEvent
import java.awt.image.BufferedImage
import javax.swing.*

class ChartDialog(val owner: JFrame, modal: Boolean, image: BufferedImage) : JDialog(owner, modal) {

    internal var chartBuilder: ChartBuilder = ChartBuilder(image)
    internal var panel = JPanel()
    internal var dataset = DefaultXYDataset()
    internal var chart = ChartFactory.createXYLineChart("Image Chart", "", "", dataset,
            PlotOrientation.VERTICAL, true, true, false
    )
    internal var chartPanel = ChartPanel(chart)

    private fun initFileMenu(): JMenuBar {
        val menuBar = JMenuBar()
        val menuEQ = JButton("EQ")
        menuBar.add(menuEQ)

        menuEQ.addActionListener(object : ValueDialog.StubActionListener(this) {
            override fun actionPerformed(e: ActionEvent) {
                val updatedImage = chartBuilder.equalize()
                val dialog = MainForm.ImageDialog(owner, false, updatedImage)
                dialog.setSize(updatedImage.width + 40, updatedImage.height + 70)
                dialog.isVisible = true

                chartBuilder.setImage(updatedImage)
                chartBuilder.build()
                dataset.removeSeries(0)
                dataset.addSeries("", chartBuilder.channel())
            }
        })

        return menuBar
    }

    init {
        panel.setSize(this.width, 0)
        panel.layout = GridLayout(0, 1)
        panel.add(chartPanel)
        this.layout = GridLayout(0, 1)
        this.add(panel)
        jMenuBar = initFileMenu()
        chartBuilder.build()
        val values = chartBuilder.channel()
        dataset.addSeries("", values)
    }
}
