close all;clear all;clc

% ��ܫݭp�� ROC �� AUC �Ϥ������| UI�A�i��ܦh��
startPath = 'C:\;'; % �_�l��ܸ��| 
% �w�]�qC�Ѷ}�l�A
% �i�H�ۦ�]�w�� MedicalImage_Project02_Segmentation �b�z���q���������|�A
% e.g. 'D:\MI_project\MedicalImage_Project02_Segmentation'�A
% �o�˴N�i�H�`�ٿ������


[fullpathname] = uigetdir2([startPath],'Select the folder of testing data (probability map)');
if isequal(fullpathname,0)
    disp('User selected Cancel.');
    return;
end

% �p���ɮ׶q
num_of_data = length(fullpathname);
fprintf(1,'Total cases : %d\n\n', num_of_data);
filename = cell(num_of_data, 1); % data name
for i = 1:num_of_data
    [~, name] = fileparts(fullpathname{i});
    filename{i} = name;
end

% Ū�� Ground truth �ιw�������v��
for i = 1:num_of_data
    testFile = filename{i};
    indexPCV = imread([fullpathname{i} ,'\gt.png']);    % ��ƶ��� /masks���|�U�۹�����GT
    temp= load([fullpathname{i} ,'\','prob.mat']);    % Predict.py �X�ӫ��x�s�� prob.mat�ɮ�
    % �bPredict.py ���槹����|���ͬ۹��������G(�ϧε��G�ξ��v��(prob.mat) ) 
    % �N�n���ժ��۹������v��(prob.mat)�Ψ�GT(data/masks���۹����ɮ�)�A
    % ��J�ݴ���Ƨ��ð���
     
    prob=temp.array;
    
    % Plot ROC ���u�έp�� AUC
    [X_ROC,Y_ROC,T_ROC,AUC_ROC] = perfcurve(reshape(indexPCV,size(indexPCV,1)*size(indexPCV,2),1), ...
                                                reshape(prob,size(prob,1)*size(prob,2),1),true);
    % �ۦ�ק�s�ɸ��|
    save(['.\ROC_result\' ,filename{i},'_ROC.mat'],  'X_ROC', 'Y_ROC', 'T_ROC', 'AUC_ROC');  
    fprintf("%s : %.6f",filename{i}, AUC_ROC);
    fprintf('\n------------------------\n')
    
end
plot(X_ROC , Y_ROC , 'c', 'LineWidth',2);  
legend(sprintf('positive (%.04f)',AUC_ROC),'Location', 'SouthEast');
saveas(gcf,'ROC','png');

