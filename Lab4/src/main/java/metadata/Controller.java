package metadata;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.Tag;
import javafx.application.Platform;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.stage.DirectoryChooser;

import java.io.File;
import java.io.IOException;

public class Controller {

    @FXML
    private TableView<ImageMetadata> data;

    @FXML
    private TableColumn<ImageMetadata, String> nameCol;

    @FXML
    private TableColumn<ImageMetadata, String> dimensionCol;

    @FXML
    private TableColumn<ImageMetadata, String> resolutionCol;

    @FXML
    private TableColumn<ImageMetadata, String> compressionCol;

    @FXML
    private TableColumn<ImageMetadata, String> fileSizeCol;

    @FXML
    private void onQuitClicked() {
        Platform.exit();
    }

    @FXML
    private void onChooseDirectoryClicked() {
        DirectoryChooser chooser = new DirectoryChooser();
        chooser.setTitle("Choose directory");
        File directory = chooser.showDialog(data.getScene().getWindow());
        loadMetadata(directory);
    }

    private void loadMetadata(File directory) {
        for (File file : directory.listFiles()) {
            try {
                Metadata metadata = ImageMetadataReader.readMetadata(file);
                loadDirectories(file.getName(), metadata);

            } catch (ImageProcessingException | IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void loadDirectories(String name, Metadata metadata) {
        ObservableList<ImageMetadata> items = data.getItems();
        for (Directory directory : metadata.getDirectories()) {
            ImageMetadata item = new ImageMetadata();
            item.setName(name);
            for (Tag tag : directory.getTags()) {
                if ("Compression Type".equals(tag.getTagName())) {
                    item.setCompression(tag.getDescription());
                }

                if ("Image Height".equals(tag.getTagName())) {
                    item.setResolution(tag.getDescription().split(" ")[0]);
                }

                if ("Image Height".equals(tag.getTagName())) {
                    item.setResolution(item.getResolution() + "x" + tag.getDescription().split(" ")[0]);
                }

                if ("X Max".equals(tag.getTagName())) {
                    item.setResolution(tag.getDescription().split(" ")[0]);
                }

                if ("Y Max".equals(tag.getTagName())) {
                    item.setResolution(item.getResolution() + "x" + tag.getDescription().split(" ")[0]);
                }

                if ("Vertical DPI".equals(tag.getTagName())) {
                    item.setDimension(tag.getDescription());
                }

                if ("Y Resolution".equals(tag.getTagName())) {
                    item.setDimension(tag.getDescription().split(" ")[0]);
                }

                if ("File Size".equals(tag.getTagName())) {
                    item.setFileSize(tag.getDescription());
                }
            }
            items.add(item);
        }
    }
}
