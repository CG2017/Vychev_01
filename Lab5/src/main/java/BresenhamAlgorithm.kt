import org.jfree.chart.ChartFactory
import org.jfree.chart.ChartPanel
import org.jfree.chart.JFreeChart
import org.jfree.chart.axis.NumberAxis
import org.jfree.chart.plot.PlotOrientation
import org.jfree.chart.plot.XYPlot
import org.jfree.data.xy.XYDataItem
import org.jfree.data.xy.XYDataset
import org.jfree.data.xy.XYSeries
import org.jfree.data.xy.XYSeriesCollection

import javax.swing.*
import java.awt.*

class BresenhamAlgorithm(title: String, x0: Int, y0: Int, x1: Int, y1: Int) : JFrame(title) {

    internal var series: XYSeries
    internal var minX: Int = 0
    internal var maxX: Int = 0
    internal var minY: Int = 0
    internal var maxY: Int = 0

    init {
        this.defaultCloseOperation = WindowConstants.DISPOSE_ON_CLOSE

        val dataset = XYSeriesCollection()
        series = getCoordinates(x0, y0, x1, y1)
        dataset.addSeries(series)
        val chart = createChart(dataset)

        val chartPanel = ChartPanel(chart)
        chartPanel.background = Color.LIGHT_GRAY
        contentPane = chartPanel
    }

    fun getCoordinates(x0: Int, y0: Int, x1: Int, y1: Int): XYSeries {
        val xySeries = XYSeries("BresenhamAlgorithm")

        var deltaX = Math.abs(x1 - x0)
        var deltaY = Math.abs(y1 - y0)
        val s1 = Math.signum((x1 - x0).toFloat()).toInt()
        val s2 = Math.signum((y1 - y0).toFloat()).toInt()
        var y = y0
        var x = x0
        val changeFlag: Boolean

        if (deltaY > deltaX) {
            val temp = deltaX
            deltaX = deltaY
            deltaY = temp
            changeFlag = true
        } else {
            changeFlag = false
        }

        var t = 2 * deltaY - deltaX

        for (i in 0..deltaX) {
            xySeries.add(x.toDouble(), y.toDouble())
            while (t >= 0) {
                if (changeFlag)
                    x += s1
                else
                    y += s2
                t -= 2 * deltaX
            }
            if (changeFlag) {
                y += s2
            } else {
                x += s1
            }
            t += 2 * deltaY
        }

        return xySeries
    }

    private fun createChart(dataset: XYDataset): JFreeChart {

        val chart = ChartFactory.createXYLineChart(
                "Bresenham algorithm", // chart title
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


        minX = (series.items[0] as XYDataItem).x.toInt()
        minY = (series.items[0] as XYDataItem).y.toInt()
        maxX = (series.items[0] as XYDataItem).x.toInt()
        maxY = (series.items[0] as XYDataItem).y.toInt()
        for (item in series.items) {
            if ((item as XYDataItem).x.toInt() >= maxX) {
                maxX = item.x.toInt()
            }
            if (item.x.toInt() <= minX) {
                minX = item.x.toInt()
            }
            if (item.y.toInt() >= maxY) {
                maxY = item.y.toInt()
            }
            if (item.y.toInt() <= minY) {
                minY = item.y.toInt()
            }
        }
        plot.renderer = ScaleRenderer(false)
        val rangeAxis = plot.rangeAxis as NumberAxis
        rangeAxis.standardTickUnits = NumberAxis.createIntegerTickUnits()
        plot.getRendererForDataset(plot.getDataset(0)).setSeriesPaint(0, Color.black)
        return chart

    }

}
