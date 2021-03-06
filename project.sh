#!/bin/bash

#gives permission to execute c++ programs used below
chmod +x shell_meshgenerator shell_mesh shell_extract


#allows user to update the instructions file in the shell
answ='y'
while [ $answ == 'y' ] || [ $answ == 'h' ]
do
    clear
    if [[ $answ == 'h' ]]; then
	clear
	cat help.txt
    fi
    echo "Current version of the instructions file:"
    echo "---------------------------"
    cat inst.txt
    echo "---------------------------"
    echo "Would you like to edit it? (y/n or h for help)"
    read -a line
    answ=${line[0]} 

    if [[ $answ == 'y' ]]; then
    #don't forget to save ctr-x ctr-s and exit ctr-x ctr-c    
#	emacs -nw inst.txt
	gedit inst.txt
    elif [[ $answ == 'h' ]]; then
	clear
	cat help.txt
    fi
done

#extracts ground and mesh values from the instructions file
#$? is the result (exit code) of the last executed command.
./shell_extract "Ground"
ground=$?
./shell_extract "Mesh"
mesh=$?

echo "How many custom shapes you would like to add? (0 if none)"
read num

#generates plain char mesh of the size "mesh"
./shell_meshgenerator $mesh  

#num=${line[0]}
if [[ $num == 0 ]]; then    
    ./shell_mesh $mesh $ground
fi


#allows user to draw any number of random shapes
for ((i=1;i<=$num;i++))
do
    echo "Draw your shape using any ASCII chars!"
    #allows user to draw any shape on the char mesh generated above
    #don't forget to save the changes 
    #for exmacs ctr-x ctr-s and exit ctr-x ctr-c
    # emacs -nw shell_chmesh.dat
    gedit shell_chmesh.dat
   
    echo "Enter the potential of this shape:"
    read potential
    #creates float mesh and assigns the potential to the custom boundary
    ./shell_mesh $mesh $ground $potential
    echo "Shape" $i "at potential" $potential "added!" 
done

#runs the algorithm with the instructions file
./project 1 < inst.txt

#removes garbage 
rm shell_mesh.dat shell_bmesh.dat shell_chmesh.dat
