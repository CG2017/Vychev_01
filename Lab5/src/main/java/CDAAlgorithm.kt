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

class CDAAlgorithm(title: String, xa: Int, ya: Int, xb: Int, yb: Int) : JFrame(title) {


    init {
        this.defaultCloseOperation = WindowConstants.DISPOSE_ON_CLOSE
        val dataset = XYSeriesCollection()
        dataset.addSeries(getCoordinates(xa.toFloat(), ya.toFloat(), xb.toFloat(), yb.toFloat()))
        val xylineChart = createChart(dataset)

        val chartPanel = ChartPanel(xylineChart)
        contentPane = chartPanel
    }


    fun getCoordinates(x0: Float, y0: Float, x1: Float, y1: Float): XYSeries {
        val xySeries = XYSeries("DDAAlgorithm")

        var i: Int = 1
        val L: Int
        val xStart: Int = Math.round(x0)
        val yStart: Int = Math.round(y0)
        val xEnd: Int = Math.round(x1)
        val yEnd: Int = Math.round(y1)

        val dX: Float
        val dY: Float

        L = Math.max(Math.abs(xEnd - xStart), Math.abs(yEnd - yStart))

        dX = (x1 - x0) / L
        dY = (y1 - y0) / L

        xySeries.add(x0.toDouble(), y0.toDouble())
        var xPrev = x0
        var yPrev = y0
        while (i < L) {

            xySeries.add(Math.round(xPrev + dX).toDouble(), Math.round(yPrev + dY).toDouble())
            xPrev += dX
            yPrev += dY
            i++
        }
        xySeries.add(x1.toDouble(), y1.toDouble())

        return xySeries
    }

    private fun createChart(dataset: XYDataset): JFreeChart {
        val chart = ChartFactory.createXYLineChart(
                "CDA algorithm", // chart title
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
        plot.renderer = ScaleRenderer(false)
        val rangeAxis = plot.rangeAxis as NumberAxis
        rangeAxis.standardTickUnits = NumberAxis.createIntegerTickUnits()
        plot.getRendererForDataset(plot.getDataset(0)).setSeriesPaint(0, Color.black)
        return chart

    }

}
