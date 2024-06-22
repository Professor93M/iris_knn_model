% Load the trained KNN model
knnModel = load('iris_knn_model.mat');
knnModel = knnModel.knnModel;

% Create a simple GUI
figure('Name', 'Iris Detection GUI', 'NumberTitle', 'off', 'Position', [100, 100, 400, 200]);

% Create UI components
uicontrol('Style', 'text', 'String', 'Select an image:', 'Position', [20, 160, 100, 20]);
editBox = uicontrol('Style', 'edit', 'Position', [130, 160, 150, 20]);
browseButton = uicontrol('Style', 'pushbutton', 'String', 'Browse', 'Position', [290, 160, 80, 20], 'Callback', @browseCallback);
detectButton = uicontrol('Style', 'pushbutton', 'String', 'Detect Iris', 'Position', [160, 120, 100, 30], 'Callback', @detectCallback);

% Store handles to UI components using appdata
setappdata(gcf, 'editBox', editBox);
setappdata(gcf, 'knnModel', knnModel);

% Callback function for the Browse button
function browseCallback(~, ~)
    % Get the handles to UI components using appdata
    editBox = getappdata(gcf, 'editBox');

    [filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.bmp)'}, 'Select an image');
    if isequal(filename, 0) || isequal(pathname, 0)
        return;  % User clicked Cancel
    end
    fullFilePath = fullfile(pathname, filename);
    set(editBox, 'String', fullFilePath);
end

% Callback function for the Detect Iris button
function detectCallback(~, ~)
    % Get the handles to UI components using appdata
    editBox = getappdata(gcf, 'editBox');
    knnModel = getappdata(gcf, 'knnModel');

    % Get the selected image file path from the edit box
    imagePath = get(editBox, 'String');
    
    % Check if the file exists
    if ~exist(imagePath, 'file')
        msgbox('File does not exist. Please select a valid image.', 'Error', 'error');
        return;
    end
    
    % Perform iris detection using the trained KNN model
    irisImage = imread(imagePath);
    
    % Resize the image to the common size used during training
    commonSize = [100, 100]; % Adjust based on your training
    irisImage = imresize(irisImage, commonSize);
    
    % Use the image itself as a feature (not recommended, replace with proper feature extraction)
    featureVector = double(irisImage(:)');
    
    % Predict the label using the KNN model
    predictedLabel = predict(knnModel, featureVector);
    
    % Display the result
    msgbox(['Iris detected for person: ' num2str(predictedLabel)], 'Detection Result');
end