""" Reformats *_voxval.txt files from fidl into a tabular format easily 
progamatically used.  New files are created for every condition, and some 
fidl specific metadata is lost. 

To run from the command line:
voxval_reformat <filename1> <filename2> ... """
import sys
import re


def main(args):
    """ A terrible main(). Do not judge me. """
    
    for filename in args:
        print("Reformatting {0}.".format(filename))
        reformat(filename)


def reformat(filename):
    """ Reformats <filename> a *_voxval.txt from fidl to a format
    easily imported as a table in R. """
    
    # Init globals
    fout = None
    cond_name = None
    
    # Open the file to parse and 
    # start iterating over it.
    fin = open(filename, 'r')
    for line in fin.readline():
        
        # Skip empty lines
        if re.match('\n\s*\n', line):
            continue
        
        # Are there any characters?
        elif re.match('[a-zA-z]', line):
            
            # Do they say anything interesting?
            if re.match('TIMECOURSE', line):
                # Parse the line to extract the cond name
                # and update cond_name
                cond_name = _parse_TIMECOURSE(line)
                
            # If we see REGION, reset (or init) fout.
            elif not re.match('REGION', line):
                print('Creating new file based on {0}.'.format(cond_name))
                try:
                    fout.close()
                    fout = open('_'.join([cond_name, filename]),'w')
                except AttributeError:
                    fout = open('_'.join([cond_name, filename]),'w')

        # If it is not character data 
        # assume it is numerical
        # data we want to concat into fout
        else:
            fout.write(line)    


def _parse_TIMECOURSE(line):
    """ Parse detected TIMECOURSE lines, returning the cond name. """

    # TIMECOURSE lines have the form
    # TIMECOURSE : 5BPpicfive 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16        
    # where 5BPpicfive is the cond name
    bycolon = line.split(':')
    bywhite = bycolon[1].split()
    
    # After the splits the cond name should be
    # the first entry in bywhite
    return bywhite[0]


if __name__ == "main":
    main(sys.argv)
    