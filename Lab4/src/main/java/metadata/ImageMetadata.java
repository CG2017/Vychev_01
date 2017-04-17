package metadata;

import javafx.beans.property.SimpleStringProperty;

/**
 * Created by andrey on 4/16/17.
 */
public class ImageMetadata {

    private SimpleStringProperty name;
    private SimpleStringProperty dimension;
    private SimpleStringProperty resolution;
    private SimpleStringProperty compression;
    private SimpleStringProperty fileSize;

    public ImageMetadata(String name,
                         String dimension,
                         String resolution,
                         String compression,
                         String fileSize) {
        this();
        this.name.set(name);
        this.dimension.set(dimension);
        this.resolution.set(resolution);
        this.compression.set(compression);
        this.fileSize.set(fileSize);
    }

    public ImageMetadata() {
        name = new SimpleStringProperty("");
        dimension = new SimpleStringProperty("");
        resolution = new SimpleStringProperty("");
        compression = new SimpleStringProperty("");
        fileSize = new SimpleStringProperty("");
    }

    public String getName() {
        return name.get();
    }

    public void setName(String name) {
        this.name.set(name);
    }

    public String getDimension() {
        return dimension.get();
    }

    public void setDimension(String dimension) {
        this.dimension.set(dimension);
    }

    public String getResolution() {
        return resolution.get();
    }

    public void setResolution(String resolution) {
        this.resolution.set(resolution);
    }

    public String getCompression() {
        return compression.get();
    }

    public void setCompression(String compression) {
        this.compression.set(compression);
    }

    public void setFileSize(String fileSize) {
        this.fileSize.set(fileSize);
    }

    public String getFileSize() {
        return fileSize.get();
    }
}
