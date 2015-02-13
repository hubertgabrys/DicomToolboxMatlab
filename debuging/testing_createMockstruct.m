function mockstruct = createMockstruct(structure, cuboid, origin, formula)
mockstruct = zeros(cuboid(1),cuboid(2),cuboid(3));
iMin = origin;
iMax = origin+structure(1)-1;
jMin = origin;
jMax = origin+structure(2)-1;
kMin = origin;
kMax = origin+structure(3)-1;
for i = 1:cuboid(1)
	for j = 1:cuboid(2)
		for k = 1:cuboid(3)
			if (i >= iMin && i<=iMax && j >= jMin && j<=jMax && k >= kMin && k<=kMax)
				if formula==1      	
					mockstruct(i,j,k) = 1;
				elseif formula==2
<<<<<<< HEAD
					mockstruct(i,j,k) = i^2 + j^2 + k^2;
				elseif formula==3
					mockstruct(i,j,k) = i^2 + j^2;
=======
					mockstruct(i,j,k) = sqrt(((i-origin+1)/structure(1))^2 + ((j-origin+1)/structure(2))^2 + ((k-origin+1)/structure(3))^2);
				elseif formula==3
					mockstruct(i,j,k) = sqrt(((i-origin+1)/structure(1))^2 + ((j-origin+1)/structure(2))^2);
>>>>>>> testing
				end
			end
		end
	end
end
end
