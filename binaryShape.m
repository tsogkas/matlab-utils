function out = binaryShape(shape, varargin)
    % BINARYSHAPE A simple binary image containing the chosen shape. 
    %   Useful for simple tests and debugging.
    %
    %   Stavros Tsogkas, <stavros.tsogkas@ecp.fr>
    %   Last update: January 2015
    
    switch shape
        case 'rectangle'
            validArgs = {'outSize','sides','pstart','fill'};
            defaultValues = {[100,100],[50,50],[25,25],false};
            vmap = parseVarargin(varargin,validArgs,defaultValues);
            out = rectangle(vmap('outSize'),vmap('sides'),vmap('pstart'),vmap('fill'));
        case 'circle'
            validArgs = {'outSize','center','radius','fill'};
            defaultValues = {[100,100],[50,50],25,false};
            vmap = parseVarargin(varargin,validArgs,defaultValues);
            out = circle(vmap('outSize'),vmap('center'),vmap('radius'),vmap('fill'));     
        case 'line'
            validArgs = {'outSize','pstart','pend'};
            defaultValues = {[100,100],[75,25],[25,75]};
            vmap = parseVarargin(varargin,validArgs,defaultValues);
            out = line(vmap('outSize'),vmap('pstart'),vmap('pend'));                 
        otherwise
            error('This shape is not supported yet')
    end
end


function out = rectangle(outSize,sides,startxy,fill)
    out = zeros(outSize);
    a = sides(1);
    b = sides(2);
    xstart = startxy(2);
    ystart = startxy(1);
    xend = xstart + b;
    yend = ystart + a;
    if fill
        out(ystart:yend, xstart:xend) = 1;
        out(ystart:yend, xstart:xend) = 1;
    else
        out(ystart:yend, [xstart, xend]) = 1;
        out([ystart,yend], xstart:xend)  = 1;
    end
end

function out = circle(outSize,center,radius,fill)
    out = zeros(outSize);
    [x,y] = meshgrid(1:outSize(2),1:outSize(1));
    if fill
        out((x-center(2)).^2 + (y-center(1)).^2 <= radius^2) = 1;
    else
        out((x-center(2)).^2 + (y-center(1)).^2 <= (radius+1)^2 & ...
            (x-center(2)).^2 + (y-center(1)).^2 >= (radius-1)^2) = 1;
        out = bwmorph(out,'thin','inf');
    end
    out = double(out);
end

function out = line(outSize,pstart,pend)
    out = zeros(outSize);
    [x,y] = bresenham(pstart(2),pstart(1),pend(2),pend(1));
    out(sub2ind(outSize,y,x)) = 1;
end