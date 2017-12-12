package csvgenerator;

import com.opencsv.CSVWriter;
import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.imageio.ImageIO;

public class CSVGenerator {

    public static void main(String[] args) throws IOException {

        //String imageDirectory = args[0];
        //String label = args[1];
        String imageDirectory = "C:\\Skole\\Software Engineering\\7. Semester\\Datavidenskab\\Group Work\\GitHub\\Datascience\\ArtistIdentification\\Degas";
        String label = "degas";

        CSVWriter writerRed = new CSVWriter(new FileWriter(imageDirectory + "/red.csv"), ',', CSVWriter.NO_QUOTE_CHARACTER);
        CSVWriter writerGreen = new CSVWriter(new FileWriter(imageDirectory + "/green.csv"), ',', CSVWriter.NO_QUOTE_CHARACTER);
        CSVWriter writerBlue = new CSVWriter(new FileWriter(imageDirectory + "/blue.csv"), ',', CSVWriter.NO_QUOTE_CHARACTER);

        List<String[]> redLines = new ArrayList<>();
        List<String[]> greenLines = new ArrayList<>();
        List<String[]> blueLines = new ArrayList<>();

        File directory = new File(imageDirectory);
        for (File file : directory.listFiles()) {
            String[] redPixels = new String[64 * 64 + 1];
            String[] greenPixels = new String[64 * 64 + 1];
            String[] bluePixels = new String[64 * 64 + 1];

            redPixels[0] = label;
            greenPixels[0] = label;
            bluePixels[0] = label;
            
            BufferedImage image = ImageIO.read(file);
            if (image == null) {
                continue;
            }

            for (int i = 0; i < 64; i++) {
                for (int j = 0; j < 64; j++) {
                    Color color = new Color(image.getRGB(i, j));
                    redPixels[j + i * 64 + 1] = Integer.toString(color.getRed());
                    greenPixels[j + i * 64 + 1] = Integer.toString(color.getGreen());
                    bluePixels[j + i * 64 + 1] = Integer.toString(color.getBlue());
                }
            }

            redLines.add(redPixels);
            greenLines.add(greenPixels);
            blueLines.add(bluePixels);
        }

        String[] header = new String[64 * 64 + 1];
        header[0] = "label";
        for (int i = 1; i < header.length; i++) {
            header[i] = "pixel" + Integer.toString(i);
        }

        writerRed.writeNext(header);
        writerRed.writeAll(redLines);
        writerGreen.writeNext(header);
        writerGreen.writeAll(greenLines);
        writerBlue.writeNext(header);
        writerBlue.writeAll(blueLines);

        writerRed.close();
        writerGreen.close();
        writerBlue.close();
    }

}
