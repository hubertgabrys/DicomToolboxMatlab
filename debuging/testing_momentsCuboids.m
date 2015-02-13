%% Load structure_dosecube
%[n, p] = uigetfile('*.mat', 'Choose structure_dosecube file...');
%load(strcat(p,n)); % structure_name, structure_dosecube, structure_vetrices
%clear n p;

%% Specify moments you want to have calculated.
M = [0 0 0; eye(3); 1 1 0; 1 0 1; 0 1 1; 1 1 1; 2*eye(3); 3*eye(3)]; % MOVE THIS TO EXTERNAL FILE!
% M = [1 1 0]; % MOVE THIS TO EXTERNAL FILE!
%M = [0;1;2;3;4]
disp('Will calculate following scale invariant moments: ');
disp(M);

%dimension = 50;
%mockcube3D = zeros(dimension,dimension,dimension);
%for a = 1:10
%  mockcube3D(1:(5*a),1:(2*a),1:(3*a)) = 10;
%  invariant = zeros(length(M),1);
%  % for every moment setup
%  for k = 1:length(M)
%    invariant(k) = calculateScaleInvariantMoment3D(mockcube3D, M(k,:));
%  end
%  myCSVwrite([M invariant], ['invariant_' num2str(a) '.txt'], 'p,q,r,moment\n');
%end

% dimension = 15;
% mockcube3D = zeros(dimension,dimension,dimension);
% for i = 1:dimension
%  for j = 1:dimension
%    for k = 1:dimension
%      mockcube3D(i,j,k) = sqrt(i^2+j^2);
%    end
%  end
% end

%%3D mockcubes
disp('Creating mock structures...');
cube1 = [30 30 30];
cube2 = [30 60 20];
struct1 = [20 8 12];

cube3 = [50 50 50];
cube4 = [40 30 50];
struct2 = [30 12 18];

origin1 = 1;
origin2 = 6;

mockstruct3D.s1c1o1f1 = createMockstruct(struct1, cube1, origin1, 1);
mockstruct3D.s1c1o2f1 = createMockstruct(struct1, cube1, origin2, 1);
mockstruct3D.s1c2o1f1 = createMockstruct(struct1, cube2, origin1, 1);
mockstruct3D.s1c2o2f1 = createMockstruct(struct1, cube2, origin2, 1);
mockstruct3D.s2c3o1f1 = createMockstruct(struct2, cube3, origin1, 1);
mockstruct3D.s2c3o2f1 = createMockstruct(struct2, cube3, origin2, 1);
mockstruct3D.s2c4o1f1 = createMockstruct(struct2, cube4, origin1, 1);
mockstruct3D.s2c4o2f1 = createMockstruct(struct2, cube4, origin2, 1);

mockstruct3D.s1c1o1f2 = createMockstruct(struct1, cube1, origin1, 2);
mockstruct3D.s1c1o2f2 = createMockstruct(struct1, cube1, origin2, 2);
mockstruct3D.s1c2o1f2 = createMockstruct(struct1, cube2, origin1, 2);
mockstruct3D.s1c2o2f2 = createMockstruct(struct1, cube2, origin2, 2);
mockstruct3D.s2c3o1f2 = createMockstruct(struct2, cube3, origin1, 2);
mockstruct3D.s2c3o2f2 = createMockstruct(struct2, cube3, origin2, 2);
mockstruct3D.s2c4o1f2 = createMockstruct(struct2, cube4, origin1, 2);
mockstruct3D.s2c4o2f2 = createMockstruct(struct2, cube4, origin2, 2);

mockstruct3D.s1c1o1f3 = createMockstruct(struct1, cube1, origin1, 3);
mockstruct3D.s1c1o2f3 = createMockstruct(struct1, cube1, origin2, 3);
mockstruct3D.s1c2o1f3 = createMockstruct(struct1, cube2, origin1, 3);
mockstruct3D.s1c2o2f3 = createMockstruct(struct1, cube2, origin2, 3);
mockstruct3D.s2c3o1f3 = createMockstruct(struct2, cube3, origin1, 3);
mockstruct3D.s2c3o2f3 = createMockstruct(struct2, cube3, origin2, 3);
mockstruct3D.s2c4o1f3 = createMockstruct(struct2, cube4, origin1, 3);
mockstruct3D.s2c4o2f3 = createMockstruct(struct2, cube4, origin2, 3);
disp('done!');
%for i = 1:dimension
%  mockcube3D(i,:,:) = i^2;
%end

%mockcube1D = 1:dimension;
%for i = 1:dimension
%  mockcube1D(i) = i^2;
%end

%% maxwell-boltzman distribution handle
%mbdist = @(x,a) sqrt(2/pi)*(x^2*exp((-x^2)/(2*a^2)))/a^3;
%a = 10;
%mean = 2*a*sqrt(2/pi)
%variance = (a^2*(3*pi-8))/pi
%skewness = (2*sqrt(2)*(16-5*pi))/(3*pi-8)^(3/2)
%kurtosis = 4*(-96+40*pi-3*pi^2)/(3*pi-8)^2 + 3
%for i = 1:dimension
%  mockcube1D(i) = mbdist(i, a);
%end

%% gaussian distribution
%mean = 33
%stdev = 8
%variance = stdev^2
%skewness = 0
%kurtosis = 0 + 3
%mockcube1D = normpdf(mockcube1D, mean, stdev);

%plot(1:dimension,mockcube1D);

%structure_dosecube = mockcube3D;
%% calculate moments
%raw = zeros(length(M),1);
%central = zeros(length(M),1);
%invariant = zeros(length(M),1);
% standarized = zeros(length(M),1);
fields = fieldnames(mockstruct3D);
raw = zeros(length(fields),1);
central = zeros(length(fields),1);
invariant = zeros(length(fields),1);
%for every moment setup
for k = 1:length(M)
	disp(['Calculating moment: ' num2str(M(k,:))]);
	for i = 1:numel(fields)
		disp(i)
		raw(i) = calculateMoment3D(mockstruct3D.(fields{i}), M(k,:));
		myCSVwrite([raw], ['output/raw_' strrep(num2str(M(k,:)), ' ', '') '.txt'], [num2str(M(k,:)) '\n']);
		central(i) = calculateCentralMoment3D(mockstruct3D.(fields{i}), M(k,:));
		myCSVwrite([central], ['output/central_' strrep(num2str(M(k,:)), ' ', '') '.txt'], [num2str(M(k,:)) '\n']);
		invariant(i) = calculateScaleInvariantMoment3D(mockstruct3D.(fields{i}), M(k,:));
		myCSVwrite([invariant], ['output/invariant_' strrep(num2str(M(k,:)), ' ', '') '.txt'], [num2str(M(k,:)) '\n']);
	end
	disp('done!');
    % calculate scale invariant moments
%    raw(k) = calculateMoment3D(structure_dosecube, M(k,:));
%    central(k) = calculateCentralMoment3D(structure_dosecube, M(k,:));
%    invariant(k) = calculateScaleInvariantMoment3D(structure_dosecube, M(k,:));
    %standarized(k) = calculateStandarizedMoment1D(structure_dosecube, M(k,:));
end
%myCSVwrite([M raw], 'raw_.txt', 'p,q,r,moment\n');
%myCSVwrite([M central], 'central_.txt', 'p,q,r,moment\n');
%myCSVwrite([M invariant], 'invariant_.txt', 'p,q,r,moment\n');
%myCSVwrite([M standarized], 'standarized_.txt', 'p,q,r,moment\n');