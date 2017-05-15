package chart

import java.awt.*
import java.awt.image.*

class ChartBuilder(internal var image: BufferedImage) {
    lateinit internal var channel: Array<DoubleArray>

    fun build() {
        channel = Array(2) { DoubleArray(256) }
        for (i in 0..255) {
            channel[0][i] = i.toDouble()
            channel[1][i] = 0.0
        }
        val data = image.data.dataBuffer
        for (i in 0..data.size - 1) {
            channel[1][data.getElem(i)]++
        }
    }

    fun equalize(): BufferedImage {
        val normalizedChannel = normalize()
        val integralHistogram = DoubleArray(256)
        for (i in 0..255) {
            integralHistogram[i] = 0.0
            for (j in 0..i - 1) {
                integralHistogram[i] += normalizedChannel[j]
            }
        }
        val updatedImage = copyImage(image)
        val data = image.data.dataBuffer
        for (i in 0..data.size - 1) {
            var gray = data.getElem(i)
            gray = (integralHistogram[gray] * 255).toInt()
            data.setElem(i, gray)
        }
        updatedImage.data = Raster.createRaster(updatedImage.data.sampleModel, data, Point(0, 0))
        return updatedImage
    }

    private fun normalize(): DoubleArray {
        val normalizedChannel = DoubleArray(256)
        for (i in 0..255) {
            normalizedChannel[i] = channel[1][i] / image.data.dataBuffer.size
        }
        return normalizedChannel
    }

    internal fun channel(): Array<DoubleArray> {
        return channel
    }

    private fun copyImage(bi: BufferedImage): BufferedImage {
        val cm = bi.colorModel
        val isAlphaPremultiplied = cm.isAlphaPremultiplied
        val raster = bi.copyData(null)
        return BufferedImage(cm, raster, isAlphaPremultiplied, null)
    }

    fun setImage(image: BufferedImage) {
        this.image = image
    }
}
