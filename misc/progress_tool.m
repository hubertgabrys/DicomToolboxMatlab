function progress_tool(currentIndex, totalNumberOfEvaluations)
 
if (currentIndex > 1 && nargin < 3)
  Length = numel(sprintf('%3.2f%%',(currentIndex-1)/totalNumberOfEvaluations*100));
  fprintf(repmat('\b',1,Length));
end
fprintf('%3.2f%%',currentIndex/totalNumberOfEvaluations*100);
end