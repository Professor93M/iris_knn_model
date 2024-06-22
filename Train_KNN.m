% Specify the path to the dataset
datasetPath = 'UBIRIS';

% Initialize variables to store features and labels
features = [];
labels = [];

% Common size for resizing images
commonSize = [100, 100]; % Adjust this based on your requirements

% Loop through each folder
for folderIndex = 1:241
    folderName = sprintf('%01d', folderIndex);
    folderPath = fullfile(datasetPath, folderName);

    % Load and process each image in the folder
    for imageIndex = 1:4
        imageName = sprintf('person (%01d).jpg', imageIndex);
        imagePath = fullfile(folderPath, imageName);

        % Print the full file path for debugging
        disp(['Processing image: ' imagePath]);

        % Perform image processing and feature extraction (replace this with your own code)
        % Resize the image to a common size
        irisImage = imread(imagePath);
        irisImage = imresize(irisImage, commonSize);

        % Use the image itself as a feature (not recommended, replace with proper feature extraction)
        featureVector = double(irisImage(:)');

        % Store features and labels
        features = [features; featureVector];
        labels = [labels; folderIndex];
    end
end

% Train KNN model
knnModel = fitcknn(features, labels, 'NumNeighbors', 3);

% Save the trained model for future use
save('iris_knn_model.mat', 'knnModel');
disp('KNN model trained and saved.');
