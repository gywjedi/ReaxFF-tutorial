clear
num_atoms = 3600;
C_code = 67;
H_code = 72;
O_code = 79;
box_length = [80.00, 80.00, 80.00];

fidin = fopen('C2H6O_400.xyz','r'); 
if fidin == -1
    error('Failed to open the file. Please check!');
end

for i=1:2
    tline = fgets(fidin);
end

System = zeros(num_atoms,6);
System(:,1) = (1:num_atoms);
System(:,3) = 0;

for i = 1:num_atoms
        str = fgetl(fidin);
        num = sscanf(str, '%s %f %f %f');

        System_Original(i,:) = num;

        if System_Original(i,1) == C_code
           System_Original(i,1) = 1;
        end
         if System_Original(i,1) == H_code
           System_Original(i,1) = 2;
         end
        if System_Original(i,1) == O_code
           System_Original(i,1) = 3;
        end
end

xyz = [min(System_Original(:,2)), max(System_Original(:,2)),...
       min(System_Original(:,3)), max(System_Original(:,3)),...
       min(System_Original(:,4)), max(System_Original(:,4))];

centroid = [0.5*(xyz(2)-xyz(1)), ...
            0.5*(xyz(4)-xyz(3)), ...
            0.5*(xyz(6)-xyz(5))];

for i = 1:num_atoms
    System_Original(i,2:4) = System_Original(i,2:4) - centroid;
end

System(:,2) = System_Original(:,1);
System(:,4:6) = System_Original(:,2:4);

outfilename = 'C2H6O_400.data';
fidout = fopen(outfilename, 'w');
header =  ('# converting xyz file to data file.');
fprintf(fidout,'%s\n\n',header);
fprintf(fidout,'%d\t %s\n',num_atoms,'atoms'); 
fprintf(fidout,'%d\t %s\n\n',3,'atom types');

X1 = min(System(:,4));
X2 = max(System(:,4));
Y1 = min(System(:,5));
Y2 = max(System(:,5));
Z1 = min(System(:,6));
Z2 = max(System(:,6));

% xlo = floor(X1);
% xhi = ceil(X2);
% ylo = floor(Y1);
% yhi = ceil(Y2);
% zlo = floor(Z1);
% zhi= ceil(Z2);

xlo = -box_length(1)/2;
xhi = box_length(1)/2;
ylo = -box_length(2)/2;
yhi = box_length(2)/2;
zlo = -box_length(3)/2;
zhi = box_length(3)/2;


fprintf(fidout,'%f  %f \t%s\n',xlo,xhi,'xlo xhi'); 
fprintf(fidout,'%f  %f \t%s\n',ylo,yhi,'ylo yhi');
fprintf(fidout,'%f  %f \t%s\n\n',zlo,zhi,'zlo zhi');

fprintf(fidout,'%s\n\n','Masses'); 
fprintf(fidout,'%d\t %f\n',1, 12.0107);
fprintf(fidout,'%d\t %f\n',2, 1.0080);
fprintf(fidout,'%d\t %f\n\n',3, 15.9994);

fprintf(fidout,'%s\n\n','Atoms');
fprintf(fidout,'%d\t %d\t %f\t %f\t %f\t %f\n', System');
fclose(fidout);