function [pathname] = uigetdir2(start_path, dialog_title, multiSelect)
% start_path   : absolute path (recommended); empty string for current folder
% dialog_title : the title of dialog
% multiSelect  : set multi-selection mode (default to true)
% 

import javax.swing.JFileChooser;

if nargin == 0 || strcmp(start_path, '')
    start_path = pwd;
end

jchooser = javaObjectEDT('javax.swing.JFileChooser', start_path);

jchooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);

if nargin > 1
    jchooser.setDialogTitle(dialog_title);
end

if nargin < 3
    multiSelect = true;
end

jchooser.setMultiSelectionEnabled(multiSelect);

status = jchooser.showOpenDialog([]);

if status == JFileChooser.APPROVE_OPTION
    if multiSelect
        jFile = jchooser.getSelectedFiles();
    else
        jFile = jchooser.getSelectedFile();
    end
    pathname = cell(size(jFile, 1), 1);
    for i=1:size(jFile, 1)
        pathname{i} = char(jFile(i).getAbsolutePath);
    end
	
elseif status == JFileChooser.CANCEL_OPTION
    pathname = 0;
else
    error('Error occured while picking file.');
end

end