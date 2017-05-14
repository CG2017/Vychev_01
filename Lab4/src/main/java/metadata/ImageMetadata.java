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
    private SimpleStringProperty fileModifiedDate;
    private SimpleStringProperty orientation;
    private SimpleStringProperty other;

    public ImageMetadata(String name,
                         String dimension,
                         String resolution,
                         String compression,
                         String fileSize,
                         String fileModifiedDate,
                         String orientation,
                         String other) {
        this();
        this.fileModifiedDate.set(fileModifiedDate);
        this.orientation.set(orientation);
        this.name.set(name);
        this.dimension.set(dimension);
        this.resolution.set(resolution);
        this.compression.set(compression);
        this.fileSize.set(fileSize);
        this.other.set(other);
    }

    public ImageMetadata() {
        orientation = new SimpleStringProperty("");
        fileModifiedDate = new SimpleStringProperty("");
        name = new SimpleStringProperty("");
        dimension = new SimpleStringProperty("");
        resolution = new SimpleStringProperty("");
        compression = new SimpleStringProperty("");
        fileSize = new SimpleStringProperty("");
        other = new SimpleStringProperty("");
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

    public String getFileModifiedDate() {
        return fileModifiedDate.get();
    }

    public void setFileModifiedDate(String fileModifiedDate) {
        this.fileModifiedDate.set(fileModifiedDate);
    }

    public void setOrientation(String orientation) {
        this.orientation.set(orientation);
    }

    public String getOrientation() {
        return orientation.get();
    }

    public String getOther() {
        return other.get();
    }

    public void setOther(String other) {
        this.other.set(other);
    }
}
