import org.jfree.chart.axis.ValueAxis
import org.jfree.chart.plot.CrosshairState
import org.jfree.chart.plot.PlotRenderingInfo
import org.jfree.chart.plot.XYPlot
import org.jfree.chart.renderer.xy.XYItemRendererState
import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer
import org.jfree.data.xy.XYDataset
import org.jfree.ui.RectangleEdge

import java.awt.*
import java.awt.geom.Rectangle2D

class ScaleRenderer : XYLineAndShapeRenderer {
    protected var barwidthfactor = DEFAULT_WIDTH_FACTOR
    private var isCircle = false

    private val xPrev = 0.0
    private val yPrev = 0.0

    protected var thedot: Shape? = null

    constructor(factor: Double, isCircle: Boolean) : this(isCircle) {
        this.barwidthfactor = factor

    }

    constructor(isCircle: Boolean) : super() {
        baseLinesVisible = false
        baseShapesVisible = true
        this.isCircle = isCircle
    }

    override fun initialise(g2: Graphics2D?,
                            dataArea: Rectangle2D?,
                            plot: XYPlot?,
                            data: XYDataset?,
                            info: PlotRenderingInfo): XYItemRendererState {
        thedot = null
        return super.initialise(g2, dataArea, plot, data, info)
    }

    override fun drawItem(g2: Graphics2D, state: XYItemRendererState,
                          dataArea: Rectangle2D, info: PlotRenderingInfo?, plot: XYPlot,
                          domainAxis: ValueAxis, rangeAxis: ValueAxis, dataset: XYDataset,
                          series: Int, item: Int, crosshairState: CrosshairState, pass: Int) {

        if (thedot == null) {
            val yDist = 1.0
            val xDist = 1.0
            var width = 0.0
            var height = 0.0
            val domainEdge = plot.domainAxisEdge
            val rangeEdge = plot.rangeAxisEdge
            val widthms = xDist * 2 - xDist * 2 * 0.01
            val heightms = yDist * 2 - yDist * 2 * 0.01
            var left = dataset.getXValue(series, item) - widthms
            var up = dataset.getYValue(series, item) - heightms

            for (j in 0..1) { // check at least two bars to ensure an accurate width
                val right = left + widthms
                val lpos = domainAxis.valueToJava2D(left, dataArea, domainEdge)
                val rpos = domainAxis.valueToJava2D(right, dataArea, domainEdge)
                width = Math.max(width, Math.abs(rpos - lpos))
                left += widthms

                val down = up + heightms
                val upos = rangeAxis.valueToJava2D(up, dataArea, rangeEdge)
                val dpos = rangeAxis.valueToJava2D(down, dataArea, rangeEdge)
                height = Math.max(height, Math.abs(upos - dpos))
                up += heightms
            }
            width *= barwidthfactor
            height *= barwidthfactor
            thedot = Rectangle2D.Double(-width * 0.5, -height * 0.5, width, height)

        }

        val maxX = plot.getDataRange(plot.domainAxis).upperBound + 10
        val minX = plot.getDataRange(plot.domainAxis).lowerBound - 10

        val maxY = plot.getDataRange(plot.rangeAxis).upperBound + 10
        val minY = plot.getDataRange(plot.rangeAxis).lowerBound - 10

        plot.domainAxis.upperBound = maxX
        plot.domainAxis.lowerBound = minX
        super.drawItem(g2, state, dataArea, info, plot, domainAxis, rangeAxis, dataset, series, item, crosshairState, pass)
    }

    override fun getItemShape(series: Int, item: Int): Shape {
        return thedot!!
    }

    companion object {
        protected val DEFAULT_WIDTH_FACTOR = 0.5
    }
}