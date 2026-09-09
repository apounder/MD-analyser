#!/bin/bash

# This script processes multiple trajectory files and combines results into a single output file.

PRMTOP="rep*/stripped-rep.prmtop"
TRAJFILES=( rep*/*stripped*.nc )  # Store all trajectory files in an array
REF_NUM="24"
REF_RES=":24@C1,C2,C3,C4,C5,C6"
AROMATIC_RES=":I2G,I2A,I2C,I2U,I1G,I1A,I1C,I1U,U5,U3,A5,A3,T5,T3,G5,G3,C5,C3,DA5,DA3,DT5,DT3,DG5,DG3,DC5,DC3,DA,DT,DG,DC,A,T,G,C,U,PHE,TYR,Phe,Tyr,HIS,His,HIP,Hip,HID,Hid,TRP,Trp,ARG,Arg,G3M,G5M,C3M,C5M,LNA,ARG,Arg"

cutoff_distance1="5"
MINDIST="0"
MAXDIST="5"
MINANG1="0"
MAXANG1="30"
MINANG2="150"
MAXANG2="180"

# Create output directory
mkdir -p donor-stacking

# Combined output file
COMBINED_OUTPUT="donor-stacking/ALL-stacking-combined-$REF_NUM.dat"
> "$COMBINED_OUTPUT"  # Clear previous combined results

for TRAJFILE in "${TRAJFILES[@]}"; do
    echo "Processing trajectory: $TRAJFILE"
    
    TEMP_OUTPUT="donor-stacking/temp-$(basename "$TRAJFILE" .nc)-$REF_NUM.dat"
    > "$TEMP_OUTPUT"  # Temporary file for this trajectory
    
    cat <<EOF > get_distance_frames.in
parm $PRMTOP
trajin $TRAJFILE
mask ($REF_RES<@$cutoff_distance1)&($AROMATIC_RES)&!($(echo "$REF_RES" | grep -o ":[0-9]\+")) maskout wedge_frames.dat
run
quit
EOF

    cpptraj -i get_distance_frames.in > /dev/null
    awk '{ print $4$5 }' wedge_frames.dat | sed '1d' | sort | uniq > stacking_residues.log
    
    cat <<EOF > stacking.in
parm $PRMTOP
trajin $TRAJFILE
vector VECT-ref-ring corrplane $REF_RES
EOF
    
    for res in $(cat stacking_residues.log); do
        residue=$(echo "$res" | grep -o "^[0-9].*" | sed '0,/[0-9]*/{s/^[0-9]*//g}')
        case $residue in
            I2U|I2C|I1U|I1C|DC5|DC3|DT5|DT3|C5|C3|U5|U3|DC|C|DT|T|U|C3M|C5M|LNT)
                echo "vector VECT-$res-ring corrplane :$(echo "$res" | grep -o "^[0-9]\+")@N1,C2,N3,C4,C5,C6" >> stacking.in
                echo "distance DIST-$res :$(echo "$res" | grep -o "^[0-9]\+")@N1,C2,N3,C4,C5,C6 $REF_RES out stacking-$res.out" >> stacking.in
                ;;
            I2A|I2G|I1A|I1G|DG5|DG3|DA5|DA3|A5|A3|G5|G3|DA|A|DG|G|G3M|G5M|LNA)
                echo "vector VECT-$res-ring corrplane :$(echo "$res" | grep -o "^[0-9]\+")@N1,C2,N3,C4,C5,C6,N7,C8,N9" >> stacking.in
                echo "distance DIST-$res :$(echo "$res" | grep -o "^[0-9]\+")@N1,C2,N3,C4,C5,C6,N7,C8,N9 $REF_RES out stacking-$res.out" >> stacking.in
                ;;
            PHE|Phe|Tyr|TYR)
                echo "vector VECT-$res-ring corrplane :$(echo "$res" | grep -o "^[0-9]\+")@CG,CD1,CD2,CE1,CE2,CZ" >> stacking.in
                echo "distance DIST-$res :$(echo "$res" | grep -o "^[0-9]\+")@CG,CD1,CD2,CE1,CE2,CZ $REF_RES out stacking-$res.out" >> stacking.in
                ;;
            HIS|His|HIP|Hip|HID|Hid)
                echo "vector VECT-$res-ring corrplane :$(echo "$res" | grep -o "^[0-9]\+")@CG,ND1,CD2,CE1,NE2" >> stacking.in
                echo "distance DIST-$res :$(echo "$res" | grep -o "^[0-9]\+")@CG,ND1,CD2,CE1,NE2 $REF_RES out stacking-$res.out" >> stacking.in
                ;;
            TRP|Trp)
                echo "vector VECT-$res-ring corrplane :$(echo "$res" | grep -o "^[0-9]\+")@CG,CD1,CD2,NE1,CE2,CE3,CZ2,CZ3,CH2" >> stacking.in
                echo "distance DIST-$res :$(echo "$res" | grep -o "^[0-9]\+")@CG,CD1,CD2,NE1,CE2,CE3,CZ2,CZ3,CH2 $REF_RES out stacking-$res.out" >> stacking.in
                ;;
			ARG|Arg)
                echo "vector VECT-$res-ring corrplane :$(echo "$res" | grep -o "^[0-9]\+")@CZ,NH1,NH2,NE" >> stacking.in
                echo "distance DIST-$res :$(echo "$res" | grep -o "^[0-9]\+")@CZ,NH1,NH2,NE $REF_RES out stacking-$res.out" >> stacking.in
                ;;
            *)
                ;;
        esac
        echo "vectormath vec1 VECT-ref-ring vec2 VECT-$res-ring out stacking-$res.out dotangle name $res-DOTANGLE" >> stacking.in
        echo "calcstate state stacked,DIST-$res,$MINDIST,$MAXDIST,$res-DOTANGLE,$MINANG1,$MAXANG1 state stacked,DIST-$res,$MINDIST,$MAXDIST,$res-DOTANGLE,$MINANG2,$MAXANG2 out stacking-$res.dat countout stacking-count-$res.dat" >> stacking.in
    done

    echo "run
quit" >> stacking.in
    
    cpptraj -i stacking.in > /dev/null
    tail -n +1 stacking-count-*.dat >> "$TEMP_OUTPUT"
    sed -i '/^$/d' "$TEMP_OUTPUT"
    sed -i '/State_/d' "$TEMP_OUTPUT"
    
    # Add the trajectory name to each line and append to combined file
    traj_name=$(basename "$TRAJFILE" .nc)
    awk -v traj="$traj_name" '{print traj, $0}' "$TEMP_OUTPUT" >> "$COMBINED_OUTPUT"
    
    # Clean up temporary files
    script_name=$(basename "$0" .sh)
    mkdir -p "$script_name"
    mv stacking*.dat stacking-*.out wedge_frames.dat "$script_name"
    rm "$TEMP_OUTPUT"
    
    echo "$REF_RES ...Done"
done

echo "Processing complete. Combined results saved in $COMBINED_OUTPUT"