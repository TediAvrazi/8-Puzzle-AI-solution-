clc
clear

%Choose herustic
herustic=2;

%Iterate start 8-puzzle. 
%Check if puzzle is solveble, otherwize generates new puzzle. 
Inversions=1;
while mod(Inversions,2) 
Random_nr=[0:8];
Start_values=Random_nr(randperm(length(Random_nr)));



%Count number of inversions, high number before low. IF odd count, not solble. 
Copy_start_values=Start_values;
Copy_start_values(find(Copy_start_values==0))=[]; %Remove the zero

Inversions=0;
for j=1:length(Copy_start_values)-1
for i=1:length(Copy_start_values)-j
if Copy_start_values(j)>Copy_start_values(j+i)
Inversions=Inversions+1;
end
end
end
end


%Place the random integer vector into a matrix.
for i=(1:3) 
%Creates a 3d array. %Row, Column, Depth 
State(i,:,1)=Start_values(3*i-2:3*i);  
end;



%Number of Wrongly placed tiles or manhattan
if herustic==1
h(1)=Wrongly_placed_tiles(State(:,:,1));
elseif herustic==2;
h(1)=Manhattan_distance(State(:,:,1));
end;
g(1)=0;
f(1)=h(1)+g(1);

%Goal State
Goal_State= [1 2 3 ; 4 5 6; 7 8 0]; 

%Closed or open state in a vector
%Open =1, closed = 0 ; 
Open_Closed(1)=1; 

%Counter to keep track of # of states and activity that led to current
%state. 
Activity_that_led_to_current_pos(1)="Null";
counter=2;


while min(h)~=0 
%for j=1:1
%Choose were to expand at position index
[min_f,index]=min(f); 

% f_flip=flip(f);
% % % 
% [min_f,index]=min(f_flip); 
% Number=flip([1:length(f_flip)]);
% index=Number(index);


%Find position of zero 
[y,x]=find(State(:,:,index)==0);




%Expanding in all possible directions. 
move=["rigth","left","up","down"]; %To keep track of action. 
change_x=[1,-1,0,0]; %Used for swapping
change_y=[0,0,-1,1];
opposite_move=["left","rigth","down","up"];

%When closing increase the f(s) value to avoid reusing a closed state. 
Open_Closed(index)=0;
f_closed(index)=f(index);
f(index)=1000;



for i=(1:4) %For all "maybe" possible actions"
    
%Should not reverse the last action 
if Activity_that_led_to_current_pos(index)~=opposite_move(i);
   

%Check to see if we can do the action 
if i==1 & x==3    
elseif i==2 & x==1 
elseif i==3 & y==1 
elseif i==4 & y==3   
    
else 
%Makes a copy of the wanted expand state
State(:,:,counter)=State(:,:,index); 

State(y,x,counter) = State(y+change_y(i),x+change_x(i),index); %Make the swap
State(y+change_y(i),x+change_x(i),counter) = State(y,x,index);


if herustic==1
h(counter)=Wrongly_placed_tiles(State(:,:,counter));
elseif herustic==2;
h(counter)=Manhattan_distance(State(:,:,counter));
end;

g(counter)=g(index)+1; 
f(counter)=h(counter)+g(counter);


%Open up new state
Open_Closed(counter)=1; 
Activity_that_led_to_current_pos(counter)=move(i);


%VI har dubblar i state fortfarande...

%If new state = some closed old state --> Close it. 
for m=1:length(Open_Closed)-1
if Open_Closed(m)==0 
%If they are the same shut the new state. Prevent 00 loop 
if sum(State(:,:,m)==State(:,:,counter),'all')==9 
Open_Closed(counter)=0;
State(:,:,counter)=[]; %Remove.
f(counter)=[];
%break; %Exits the loop 
counter=counter-1;
break;
end
end 
end 


%Checker if we are done if h=0. Then break loop. 
if min(h)==0
break
end

counter=counter+1;
end 
end




end 

% %Infinity check
% for n=1:length(Open_Closed)
% for m=1:length(Open_Closed) 
% 
% %Our preventation for the infinity loop doesn work. 
% if sum(State(:,:,m)==State(:,:,n),'all')==9 & m~=n
%   Open_Closed(m)=0;
% f_closed(m)=f(m);
% f(m)=1000;
% "HEJ"
% break;
% end
% end
% end





end


%Solution route with both moves of the zero and all passed states to the
%goal
disp("Solution after")
Iterations=counter

disp("Solution route")
A=[""];
[value,pos]=min(h);
a=1;

Previous_state(:,:,1)=State(:,:,pos);

while sum(Previous_state(:,:,a)==State(:,:,1),'all') ~= 9

a=a+1;

if a>50
    break
end

A(end+1)=Activity_that_led_to_current_pos(pos);

%if Activity_that_led_to_current_pos(pos)=="Null"
 %break

%end 
[y,x]=find(State(:,:,pos)==0);


if Activity_that_led_to_current_pos(pos)=="rigth"
i=2;
elseif Activity_that_led_to_current_pos(pos)=="left"
i=1;
elseif Activity_that_led_to_current_pos(pos)=="down"
i=3;    
elseif Activity_that_led_to_current_pos(pos)=="up"
i=4;   
end

%Check to see if we can do the action 
if i==1 & x==3    
elseif i==2 & x==1 
elseif i==3 & y==1 
elseif i==4 & y==3   
    
else 

 %Finds the previous state
Previous_state(:,:,a)=State(:,:,pos); 

Previous_state(y,x,a) = State(y+change_y(i),x+change_x(i),pos); %Make the swap
Previous_state(y+change_y(i),x+change_x(i),a) = State(y,x,pos);
end

for k=1:length(State)
if Previous_state(:,:,a)==State(:,:,k) & Open_Closed(k)==0
pos=k; %Finds the position of the previous state. 
end
end
end

%Flips the matrix 
for p=1:length(Previous_state(1,1,:)) 
Solution_path(:,:,p)=Previous_state(:,:,end+1-p);
end
A;
Moves_of_zero_to_reach_goal=A(2:length(A)-1)
State(:,:,1);

% for n=1:length(Open_Closed)
% for m=1:length(Open_Closed)
% %if Open_Closed(j)==0 
%  
% 
% %Our preventation for the infinity loop doesn work. 
% if sum(State(:,:,m)==State(:,:,n),'all')==9 & m~=n
% 
% "HSKIT"
% m
% n
% break;
% end
% end
% end




%% Function for caluculating h
function h=Wrongly_placed_tiles(State) %Input the matrix (rows,columns)
Rigth_order= [1 2 3 ; 4 5 6; 7 8 0];

Rigth_placed_tiles=sum(State(:,:)==Rigth_order(:,:),'all');  % Sum of rigthly placed numbers. From sum over boolean

%Exception the 0 should not be counted.
if State(3,3)==0 
  Rigth_placed_tiles=Rigth_placed_tiles-1;
end 
Rigth_placed_tiles;

h=8-Rigth_placed_tiles;
Rigth_placed_tiles=0;
end 



%% Manhattan distance
function h=Manhattan_distance(State)
h=0;
i=1;

for j=1:3
for k=1:3

if j==3 & k==3 %Dont want to check the 0
    
else
%Find position of all variables 
[y,x]=find(State==i);
i=i+1;
h=h+abs(j-y)+abs(k-x);
end
end
end

end
