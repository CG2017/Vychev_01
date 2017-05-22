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

class ScaleRenderer() : XYLineAndShapeRenderer() {
    private val barwidthfactor = DEFAULT_WIDTH_FACTOR
    private var thedot: Shape? = null

    init {
        baseLinesVisible = false
        baseShapesVisible = true
        useOutlinePaint = true
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
            var width = 0.0
            var height = 0.0
            val domainEdge = plot.domainAxisEdge
            val rangeEdge = plot.rangeAxisEdge
            val widthms = 1.0
            var left = dataset.getXValue(series, item).toInt() - widthms
            var top = dataset.getYValue(series, item).toInt() - widthms

            for (j in 0..1) {
                val right = left + widthms
                val bottom = top + widthms
                val lpos = domainAxis.valueToJava2D(left, dataArea, domainEdge)
                val rpos = domainAxis.valueToJava2D(right, dataArea, domainEdge)
                val tpos = rangeAxis.valueToJava2D(top, dataArea, rangeEdge)
                val bpos = rangeAxis.valueToJava2D(bottom, dataArea, rangeEdge)
                width = Math.max(width, Math.abs(rpos - lpos))
                height = Math.max(height, Math.abs(tpos - bpos))
                left += widthms
                top += widthms
            }

            width *= barwidthfactor
            height *= barwidthfactor
            thedot = Rectangle(0, (-height).toInt(), width.toInt(), height.toInt())
        }

        super.drawItem(g2, state, dataArea, info, plot, domainAxis, rangeAxis, dataset, series, item, crosshairState,
                pass)
    }

    override fun getItemShape(series: Int, item: Int): Shape {
        return thedot!!
    }

    companion object {
        private val DEFAULT_WIDTH_FACTOR = 1.0
    }
}