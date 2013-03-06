#! /usr/local/bin/python
""" Reformats *_vox.txt files from fidl into a tabular format easily 
progamatically used.  A column is added to the left for each condition found
in the *_vox.txt file.  Some fidl metadata is lost. 

NOTE: If you have l evels, or any character data in the timecourse data proper, 
it must be in lower case ONLY.  Uppercase characters outside of the fidl 
metadata/formatting will break the script.
 
To run from the command line (there are no options or flags):
voxval_reformat <filename1> <filename2> ... """
import sys
import re
import os


def main(args):
    """ A terrible main(). Do not judge me. """

    print(args)
    for filename in args:
        print("Reformatting {0}.".format(filename))
        reformat(filename)


def reformat(filename):
    """ Reformats <filename> a *_vox.txt from fidl to a format
    easily imported as a table in R. """
    
    # Init globals
    cond_name = None
    
    # Create the out_filename 
    path, nameonly = os.path.split(filename)
    out_nameonly = '_'.join(['conds', nameonly])
    out_filename = os.path.join(path, out_nameonly)
    
    # Open the out file.
    fout = open(out_filename,'w')
        
    # Open the file to parse and 
    # start iterating over it.
    fin = open(filename, 'r')
    for line in iter(fin):
        # Skip empty lines
        if not line.strip():
            continue
        
        # Are there any characters?
        elif re.match('[A-Z]', line):
            # Do they say anything interesting?
            if re.match('TIMECOURSE', line):
                # Parse the line to extract the cond name
                # and update cond_name
                cond_name = _parse_TIMECOURSE(line)
                print('New cond: {0}'.format(cond_name))
            
            continue
        # If it is not character data 
        # assume it is numerical
        # data we want to concat into fout
        else:
            fout.write('\t'.join([cond_name, line]))


def _parse_TIMECOURSE(line):
    """ Parse detected TIMECOURSE lines, returning the cond name. """

    # TIMECOURSE lines have the form
    # TIMECOURSE : 5BPpicfive 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16        
    # where 5BPpicfive is the cond name
    
    bycolon = line.split(':')[1]  ## 2 parts, we want the second
    bywhite = bycolon.split()

    # After the splits the cond name should be
    # the first entry in bywhite
    return bywhite[0]


if __name__ == "__main__":
    main(sys.argv[1:])
    