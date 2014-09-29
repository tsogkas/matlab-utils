% Extend input images to the maximum of their heights and widths, without
% affecting their xy plane coordinates. If in2 is a vector, it is used to 
% set the dimensions of in1 to specific height and width.
% 
% 
% Stavros Tsogkas, December 2012
% <stavros.tsogkas@ecp.fr>
% 
% function [out1 out2] = setimsize(in1, in2)


function [out1 out2] = setimsize(in1, in2)

out1 = in1;
out2 = in2;
if isvector(in2)    % set image to specified dimensions
    sz = size(in1);
    maxsizes = max(sz(1:2),in2(1:2));
    out1 = padarray(out1,[maxsizes(1)-size(in1,1),maxsizes(2)-size(in1,2)],0,'post');
else                % adjust images to maximum height and width
    if size(in2,1)<size(in1,1)
        out2 = padarray(out2,[size(in1,1)-size(in2,1),0],0,'post');
    else
        out1 = padarray(out1,[size(in2,1)-size(in1,1),0],0,'post');
    end
    if size(in2,2)<size(in1,2)
        out2 = padarray(out2,[0,size(in1,2)-size(in2,2)],0,'post');
    else
        out1 = padarray(out1,[0,size(in2,2)-size(in1,2)],0,'post');
    end
end
