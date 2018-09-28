import subprocess
import sys

def main():
    workspace=sys.argv[1]
    main_tex=sys.argv[2]

    bash =''' 
        cd ''' + workspace + '''
        name=''' + main_tex + '''
        lualatex --output-directory=build $name
        mv build/${name%.*}.pdf ./
        
        # update .bib file if necessary
        bib=$(grep -r -F --include "*.tex" '\cite')

        if [[ $bib != "" ]]; then
            biber ./build/${name%.*}
        fi

        # if ps aux | grep okular | grep -v grep 
        #     then echo
        #     else
        #         okular ${name%.*}.pdf &
        # fi
        '''

    subprocess.call(['bash', '-c',bash])

if __name__ == '__main__':
  main()
