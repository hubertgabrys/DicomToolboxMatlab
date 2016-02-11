function scaledVec = scaleVec( vec, newValue, type)
% description
%
scaledVec = zeros(length(vec), 1);

switch type
    case 'norm'
        oldMin = min(vec);
        oldMax = max(vec);
        scaledVec = newValue*(vec-oldMin)/(oldMax-oldMin);
    case 'interval'
        scaledVec(1) = 0;
        for i=2:length(vec)
            scaledVec(i) = newValue*(i-1);
        end
end

end