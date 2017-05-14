package metadata;

import com.drew.imaging.ImageMetadataReader;
import com.drew.imaging.ImageProcessingException;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.Tag;
import javafx.application.Platform;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.stage.DirectoryChooser;

import java.io.File;
import java.io.IOException;

public class Controller {

    @FXML
    private TableView<ImageMetadata> data;

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
        ImageMetadata item = new ImageMetadata();
        item.setName(name);
        StringBuilder other = new StringBuilder();
        for (Directory directory : metadata.getDirectories()) {
            for (Tag tag : directory.getTags()) {
                System.out.println(tag.getTagName() + " " + tag.getDescription());
                if ("Compression Type".equals(tag.getTagName())) {
                    item.setCompression(tag.getDescription());
                    continue;
                }

                if ("Image Height".equals(tag.getTagName())) {
                    item.setResolution(tag.getDescription().split(" ")[0]);
                    continue;
                }

                if ("Image Width".equals(tag.getTagName())) {
                    item.setResolution(item.getResolution() + "x" + tag.getDescription().split(" ")[0]);
                    continue;
                }

                if ("X Max".equals(tag.getTagName())) {
                    item.setResolution(tag.getDescription().split(" ")[0]);
                    continue;
                }

                if ("Y Max".equals(tag.getTagName())) {
                    item.setResolution(item.getResolution() + "x" + tag.getDescription().split(" ")[0]);
                    continue;
                }

                if ("Vertical DPI".equals(tag.getTagName())) {
                    item.setDimension(tag.getDescription());
                    continue;
                }

                if ("Y Resolution".equals(tag.getTagName())) {
                    item.setDimension(tag.getDescription().split(" ")[0]);
                    continue;
                }

                if ("File Size".equals(tag.getTagName())) {
                    item.setFileSize(tag.getDescription());
                    continue;
                }

                if ("File Modified Date".equals(tag.getTagName())) {
                    item.setFileModifiedDate(tag.getDescription());
                    continue;
                }

                if ("Orientation".equals(tag.getTagName())) {
                    item.setOrientation(tag.getDescription());
                    continue;
                }

                other.append(tag.getTagName()).append(" : ").append(tag.getDescription()).append('\n');
            }
        }

        item.setOther(other.toString());
        items.add(item);
    }
}
