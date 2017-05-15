import org.jfree.chart.ChartFactory
import org.jfree.chart.ChartPanel
import org.jfree.chart.JFreeChart
import org.jfree.chart.axis.NumberAxis
import org.jfree.chart.plot.PlotOrientation
import org.jfree.chart.plot.XYPlot
import org.jfree.data.xy.XYDataset
import org.jfree.data.xy.XYSeries
import org.jfree.data.xy.XYSeriesCollection

import javax.swing.*
import java.awt.*

class BresenhamCircleAlgorithm(title: String, x0: Int, y1: Int, R: Int) : JFrame(title) {

    init {
        this.defaultCloseOperation = WindowConstants.DISPOSE_ON_CLOSE

        val dataset = XYSeriesCollection()
        dataset.addSeries(getCoordinates(x0, y1, R))
        val chart = createChart(dataset)
        val chartPanel = ChartPanel(chart)
        contentPane = chartPanel
    }


    fun getCoordinates(x1: Int, y1: Int, R: Int): XYSeries {
        val xySeries = XYSeries("BresenhamCircleAlgorithm")

        var x = R
        var y = 0
        var delta = 1 - x
        while (y <= x) {
            xySeries.add((x + x1).toDouble(), (y + y1).toDouble())
            xySeries.add((y + x1).toDouble(), (x + y1).toDouble())
            xySeries.add((-x + x1).toDouble(), (y + y1).toDouble())
            xySeries.add((-y + x1).toDouble(), (x + y1).toDouble())
            xySeries.add((-x + x1).toDouble(), (-y + y1).toDouble())
            xySeries.add((-y + x1).toDouble(), (-x + y1).toDouble())
            xySeries.add((x + x1).toDouble(), (-y + y1).toDouble())
            xySeries.add((y + x1).toDouble(), (-x + y1).toDouble())
            y++
            if (delta <= 0) {
                delta += 2 * y + 1
            } else {
                x--
                delta += 2 * (y - x) + 1
            }


        }

        return xySeries
    }

    private fun createChart(dataset: XYDataset): JFreeChart {
        val chart = ChartFactory.createXYLineChart(
                "Bresenham circle algorithm", // chart title
                "X", // x axis label
                "Y", // y axis label
                dataset, // data
                PlotOrientation.VERTICAL,
                false, // include legend
                true, // tooltips
                false                     // urls
        )

        chart.backgroundPaint = Color.white
        val plot = chart.xyPlot
        plot.backgroundPaint = Color.lightGray
        plot.domainGridlinePaint = Color.white
        plot.rangeGridlinePaint = Color.white

        plot.renderer = ScaleRenderer(true)
        val rangeAxis = plot.rangeAxis as NumberAxis
        rangeAxis.standardTickUnits = NumberAxis.createIntegerTickUnits()
        plot.getRendererForDataset(plot.getDataset(0)).setSeriesPaint(0, Color.black)

        return chart

    }
}
