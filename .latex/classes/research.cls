\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{header}[2017/03/06 My custom class]
\LoadClass{article}

\usepackage[utf8]{inputenc}	% allows certain character options
\usepackage{wrapfig}		% place text next to images
\usepackage[margin=1in]{geometry}	% change paper dimensions and margins
\usepackage{graphicx}		% manage images and graphics
\usepackage{titlesec}		% alter title settings
\usepackage{listings}		% add source code into document
\usepackage{xcolor}			% r, g, b, yellow, cyan, magenta, black, white
\usepackage{courier}		% font for Matlab Code Inserts
\usepackage{hyperref}		% creates hyper-link color options
\usepackage{caption} 		% auto-incrementing captions
\usepackage{subcaption}		% 2 captions within a figure
\usepackage{framed}			% add frame around figures
\usepackage{floatrow}	    % allows placement of figures [H]
\usepackage[parfill]{parskip}% adds newline after paragraph
\usepackage{listings}
\usepackage[linewidth=1pt]{mdframed} % package to frame figures
\usepackage{lipsum}			% package to frame figures
\usepackage{xstring}		% replace characters with others
\usepackage{xparse}			% passing parameters
\usepackage{xifthen}		% boolean if, then statements
\usepackage{xintexpr}		% use actual boolean logic
\usepackage{mfirstuc}		% capitalize first word
\usepackage[style=ieee, urldate =comp]{biblatex}% bibliography
\usepackage{enumitem} 		% edit item lists
\usepackage{pdfpages}		% include pdf documents
\usepackage[toc,page]{appendix}	% include extra TOC
\usepackage{booktabs}		% include line styles in tables
\usepackage{cleveref}		% include word Figure on reference 
\usepackage[export]{adjustbox} % allows user to move figures and pdfs
\usepackage{tabulary}		% columns size of their contents (on page)
\usepackage{amsmath}		% math equations and newline property
\usepackage{verbatim}		% make block comments



% ============================== %
%		  Package Setup
% ============================== %
\definecolor{mygreen}{RGB}{28,172,0}	% custom defined colors
\definecolor{mylilas}{RGB}{170,55,241}
\definecolor{mymauve}{rgb}{0.58,0,0.82}

\setlength\parindent{0pt}	% set no tab on new paragraphs
\parskip = \baselineskip	% set single skip after paragraphs
\setlist[itemize]{noitemsep}% remove space after item in list

\DefineBibliographyStrings{english}{% set name of bibliography
  	references = {Works Cited},	% change references to {}
}

\mdfsetup{					% framing code environment
	leftmargin 			=  0pt,
    rightmargin 		=  0pt,
    innerleftmargin 	=  15pt,
    innertopmargin		= -2pt,
    innerbottommargin 	= -2pt
}

\hypersetup{				% hyper-links environment
    colorlinks,
    linkcolor	= {black},
    citecolor	= {black},
    urlcolor	= {black},
    pdfborderstyle={/S/U/W 1}
}

\lstset{language=Matlab,	% matlab code specifications
    % basicstyle	= \color{red},
    breaklines		= true,
    morekeywords    = {matlab2tikz},
    keywordstyle    = \color{blue},
    morekeywords    = [2]{1}, keywordstyle=[2]{\color{black}},
    identifierstyle = \color{black},
    stringstyle     = \color{mylilas},
    commentstyle    = \color{mygreen},
    showstringspaces= false,
    numbers         = left,
    numberstyle     = {\tiny \color{black}},	% size of the numbers
    numbersep       = 6pt, 						% distance of numbers from text
    emph            = [1]{for, end, break}, 	% bold for, end, break...
    emphstyle 		= [1]\color{red}, 			% emphasis
	basicstyle		=\footnotesize\ttfamily		% set font to courier
}

\MFUnocap{are} \MFUnocap{or} \MFUnocap{the} \MFUnocap{a} \MFUnocap{an} \MFUnocap{and} \MFUnocap{but} \MFUnocap{for} \MFUnocap{on} \MFUnocap{at} \MFUnocap{to} \MFUnocap{from} \MFUnocap{by} \MFUnocap{etc} \MFUnocap{of}

\titlespacing{\section}{0pt}{0pt}{0pt}
\titlespacing{\subsection}{0pt}{0pt}{0pt}
\titlespacing{\subsubsection}{0pt}{0pt}{0pt}
\setlength{\belowcaptionskip}{-10pt}

% ============================== %
%  User Environments & Commands 
% ============================== %
\newcommand\textlcsc[1]{ 	% lowercase all letters
	\textsc{\MakeLowercase{#1}}
} 

\DeclareDocumentCommand{\newFigure}{m o o} {
	\edef\path{#1} \edef\figcaption{#2} \edef\size{#3}  
    % add label to figure
    \StrSubstitute{#1}{.pdf}{}[\temp]
    \StrSubstitute{\temp}{.jpg}{}[\temp]
    \StrSubstitute{\temp}{.png}{}[\temp]
    \expandafter\StrSubstitute\expandafter{\temp}{-}{ }[\temp]
    %\label{\temp} % label gets rid of type and -.
    
	
    % add size if not present
    \IfNoValueTF{#3} { % if 2 and 3 are NULL
    	\def\size{0.75}
        }{}
     
    % add caption if not present
	\IfNoValueTF{#2} { % if 2 and 3 are NULL
        %\expandafter\StrSubstitute\expandafter{\temp}{-}{ }[\output]
    	\newcommand\helphere{\temp}
		\StrBehind{\helphere}{/}[\figcaption]
    }{}
	
	\begin{figure}[H]
	\begin{center}
	\includegraphics[width=\size\textwidth]{\path}
    % I deleted the capitalize function because it wouldn't pass []
    % \capitalisewords{}
	\caption{\figcaption}
    \label{\temp} % label gets rid of type and -.
	\end{center}
	\end{figure} 
}

\DeclareDocumentCommand{\reff}{m}{
	\edef\link{#1}
    \hspace{-0.5em}\hyperref[\link]{\Cref*{\link}} \hspace{-0.65em}
}
\newcommand\frameSteupNormal{
    \mdfsetup{					% framing code environment
        leftmargin 			=  4pt,
        rightmargin 		=  4pt,
        innerleftmargin 	=  4pt,
        innertopmargin		=  6pt,
        innerbottommargin 	=  6pt
    }
}

\newcommand\frameSteupCode{
    \mdfsetup{					% framing code environment
        leftmargin 			=  0pt,
        rightmargin 		=  0pt,
        innerleftmargin 	=  15pt,
        innertopmargin		= -2pt,
        innerbottommargin 	= -2pt
    }
}

