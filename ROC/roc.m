close all;clear all;clc

% 選擇待計算 ROC 及 AUC 圖片之路徑 UI，可選擇多個
startPath = 'C:\;'; % 起始選擇路徑 
% 預設從C槽開始，
% 可以自行設定成 MedicalImage_Project02_Segmentation 在您的電腦中的路徑，
% e.g. 'D:\MI_project\MedicalImage_Project02_Segmentation'，
% 這樣就可以節省選取次數


[fullpathname] = uigetdir2([startPath],'Select the folder of testing data (probability map)');
if isequal(fullpathname,0)
    disp('User selected Cancel.');
    return;
end

% 計算檔案量
num_of_data = length(fullpathname);
fprintf(1,'Total cases : %d\n\n', num_of_data);
filename = cell(num_of_data, 1); % data name
for i = 1:num_of_data
    [~, name] = fileparts(fullpathname{i});
    filename{i} = name;
end

% 讀取 Ground truth 及預測之機率圖
for i = 1:num_of_data
    testFile = filename{i};
    indexPCV = imread([fullpathname{i} ,'\gt.png']);    % 資料集中 /masks路徑下相對應之GT
    temp= load([fullpathname{i} ,'\','prob.mat']);    % Predict.py 出來後儲存的 prob.mat檔案
    % 在Predict.py 執行完成後會產生相對應之結果(圖形結果及機率圖(prob.mat) ) 
    % 將要測試的相對應機率圖(prob.mat)及其GT(data/masks中相對應檔案)，
    % 放入待測資料夾並執行
     
    prob=temp.array;
    
    % Plot ROC 曲線及計算 AUC
    [X_ROC,Y_ROC,T_ROC,AUC_ROC] = perfcurve(reshape(indexPCV,size(indexPCV,1)*size(indexPCV,2),1), ...
                                                reshape(prob,size(prob,1)*size(prob,2),1),true);
    % 自行修改存檔路徑
    save(['.\ROC_result\' ,filename{i},'_ROC.mat'],  'X_ROC', 'Y_ROC', 'T_ROC', 'AUC_ROC');  
    fprintf("%s : %.6f",filename{i}, AUC_ROC);
    fprintf('\n------------------------\n')
    
end
plot(X_ROC , Y_ROC , 'c', 'LineWidth',2);  
legend(sprintf('positive (%.04f)',AUC_ROC),'Location', 'SouthEast');
saveas(gcf,'ROC','png');

