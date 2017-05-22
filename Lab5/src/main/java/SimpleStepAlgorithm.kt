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

class SimpleStepAlgorithm(title: String, x0: Int, y0: Int, x1: Int, y1: Int) : JFrame(title) {

    lateinit var series: XYSeries
    internal var minX: Int = 0
    internal var maxX: Int = 0
    internal var minY: Int = 0
    internal var maxY: Int = 0

    init {
        this.defaultCloseOperation = WindowConstants.DISPOSE_ON_CLOSE
        val dataset = XYSeriesCollection()
        getCoordinates(x0, y0, x1, y1)
        dataset.addSeries(series)
        val chart = createChart(dataset)
        val chartPanel = ChartPanel(chart)
        contentPane = chartPanel
    }

    fun getCoordinates(xStart: Int, yStart: Int, xEnd: Int, yEnd: Int) {
        series = XYSeries("SimpleStepAlgorithm")
        if (xStart > xEnd) {
            getCoordinates(xEnd, yEnd, xStart, yStart)
            return
        }

        var y = yStart.toFloat()
        val m = (yEnd - yStart).toFloat() / (xEnd - xStart)

        if (Math.abs(m) <= 1) {
            for (xi in xStart..xEnd) {
                series.add(xi.toDouble(), Math.round(y).toDouble())
                y += m
            }
        } else {
            rasterSteepLine(yStart, xStart, yEnd, xEnd)
        }

    }

    private fun rasterSteepLine(xStart: Int, yStart: Int, xEnd: Int, yEnd: Int) {
        if (xStart > xEnd) {
            rasterSteepLine(xEnd, yEnd, xStart, yStart)
            return
        }

        var y = yStart.toFloat()
        val m = (yEnd - yStart).toFloat() / (xEnd - xStart)
        for (xi in xStart..xEnd) {
            series.add(Math.round(y).toDouble(), xi.toDouble())
            y += m
        }
    }

    private fun createChart(dataset: XYDataset): JFreeChart {

        val chart = ChartFactory.createXYLineChart(
                "Simple algorithm", // chart title
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

        plot.renderer = ScaleRenderer()
        val rangeAxis = plot.rangeAxis as NumberAxis
        val domainAxis = plot.domainAxis
        rangeAxis.setRange(0.0, maxY + 1.0)
        domainAxis.setRange(0.0, maxX + 1.0)
        rangeAxis.standardTickUnits = NumberAxis.createIntegerTickUnits()
        plot.getRendererForDataset(plot.getDataset(0)).setSeriesPaint(0, Color.black)
        return chart

    }

}
