%
% Author: Phil
%
% forked from https://github.com/rolfn/kalenderRN
% Original author: Rolf Niepraschk
%
% inspired by http://www.texample.net/tikz/examples/a-calender-for-doublesided-din-a4/
% Original author: Robert Krause
% License: Creative Commons attribution license (CC-BY-SA)

\setcounter{errorcontextlines}{100}
\NeedsTeXFormat{LaTeX2e}[1999/12/01]
\ProvidesClass{tikz-kaligned}[2022/01/21 v0.4g Calendar class (PH)] 

\DeclareOption*{\OptionNotUsed}
\ProcessOptions\relax

\newcommand*\PH@events@files{}
\newcommand*\PH@titleFont{}
\newcommand*\PH@yearFont{}
\newcommand*\PH@monthFont{}
\newcommand*\PH@dayFont{}
\newcommand*\PH@dayNbFont{}
\newcommand*\PH@weekNbFont{}
\newcommand*\PH@weekNbColor{black}
\newcommand*\PH@eventFont{}
\newcommand*\PH@normalFont{}
\newcommand*\PH@title{}
\newcommand*\PH@year{}\edef\PH@year{\the\numexpr\year}
\newcommand*\PH@yearText{\PH@year}
\newcommand*\PH@period@name{}
\newcommand*\PH@xcolorOptions{}
\newcommand*\PH@events@I{}
\newcommand*\PH@backgrounds{}
\newcommand*\PH@periods{}
\newcommand*\PH@tempa{}
\newcommand*\PH@tempb{}

\newcommand*\PH@titleColor{dark}
\newcommand*\PH@eventColor{black}
\newcommand*\PH@eventBGColor{medium}
\newcommand*\PH@monthBGcolor{dark}
\newcommand*\PH@monthColor{white}
\newcommand*\PH@workdayColor{black}
\newcommand*\PH@workdayBGColor{none}
\newcommand*\PH@saturdayColor{dark}
\newcommand*\PH@saturdayBGColor{bright}
\newcommand*\PH@sundayColor{dark}
\newcommand*\PH@sundayBGColor{medium}
\newcommand*\PH@periodColor{period}

\newcounter{weeknumber}
\newcounter{offsetFirstday}
\newsavebox\PH@pageI
\newsavebox\PH@tempbox

\newdimen\PH@xunit
\newdimen\PH@yunit
\newdimen\PH@calheight
\newdimen\PH@calwidth
\newdimen\PH@daywidth 
\newdimen\PH@daysep
\newdimen\PH@dayheight
\newdimen\PH@eventwidthL 
\newdimen\PH@eventwidthS 

\newif\ifPH@showweeknumbers \PH@showweeknumbersfalse
\newif\ifPH@showtitle \PH@showtitletrue
\newif\ifPH@showweekdays \PH@showweekdaystrue
\newif\ifPH@print \PH@printfalse
\newif\ifPH@XeOrLua \PH@XeOrLuafalse
\RequirePackage{ifluatex,ifxetex}
\ifxetex\PH@XeOrLuatrue\else\ifluatex\PH@XeOrLuatrue\fi\fi 

\LoadClass{article}

\RequirePackage{pgfkeys,etoolbox,ragged2e}

\pgfkeys{
  /PH/.cd,
  showweeknumbers/.is if = PH@showweeknumbers,
  showtitle/.is if = PH@showtitle,
  showweekdays/.is if = PH@showweekdays,
  print/.is if = PH@print,
  events/.store in=\PH@events@files,
  titleFont/.store in=\PH@titleFont,
  yearFont/.store in=\PH@yearFont,
  monthFont/.store in=\PH@monthFont,
  dayFont/.store in=\PH@dayFont,
  dayNbFont/.store in=\PH@dayNbFont,
  weekNbFont/.store in=\PH@weekNbFont,
  weekNbColor/.store in=\PH@weekNbColor,
  eventFont/.store in=\PH@eventFont,% ???
  title/.store in=\PH@title,
  year/.store in=\PH@year,
  yearText/.store in=\PH@yearText,
  titleColor/.store in=\PH@titleColor,
  eventColor/.store in=\PH@eventColor,
  eventBGColor/.store in=\PH@eventBGColor,
  eventBGColor/.store in=\PH@eventBGColor,
  periodColor/.store in=\PH@periodColor,
  monthBGcolor/.store in=\PH@monthBGcolor,
  monthColor/.store in=\PH@monthColor,
  workdayColor/.store in=\PH@workdayColor,
  workdayBGColor/.store in=\PH@workdayBGColor,
  saturdayColor/.store in=\PH@saturdayColor,
  saturdayBGColor/.store in=\PH@saturdayBGColor,
  sundayColor/.store in=\PH@sundayColor,
  sundayBGColor/.store in=\PH@sundayBGColor,
  xcoloroptions/.code={\PassOptionsToPackage{#1}{xcolor}},
  lang/.code={\PassOptionsToPackage{#1}{babel}%
    \PassOptionsToPackage{#1}{translator}},
  paper/.code={\PassOptionsToPackage{#1paper}{geometry}}
}

\newcommand*\setup[1]{\pgfqkeys{/PH}{#1}}

\PassOptionsToPackage{a4paper}{geometry}
\PassOptionsToPackage{svgnames}{xcolor}

\ifPH@XeOrLua
  \RequirePackage{fontspec,unicode-math}
  \setmathfont{latinmodern-math}[%
    Extension=.otf,math-style=ISO,bold-style=ISO,
  ]
  \setsansfont{texgyreheros}[%
    Extension=.otf,Ligatures=TeX,
    UprightFont= *-regular,
    BoldFont=*-bold,
    ItalicFont=*-italic,
    BoldItalicFont=*-bolditalic
  ]
\else
  \RequirePackage[T1]{fontenc}
  \RequirePackage{textcomp}
  \RequirePackage{lmodern}
  \RequirePackage{tgheros}
\fi

\renewcommand*\familydefault{\sfdefault}

\AtEndPreamble{% "etoolbox"
  \ifPH@print
    \RequirePackage{graphicx}
    \PassOptionsToPackage{portrait}{geometry}
  \else
    \PassOptionsToPackage{landscape}{geometry}
  \fi
  \RequirePackage[margin={0mm,0mm}]{geometry}
  \ifPH@XeOrLua\else
    \@ifpackageloaded{inputenc}{}{\RequirePackage[utf8]{inputenc}}%
  \fi
  \RequirePackage{babel,translator,tikz}
  \@ifpackagelater{pgf}{2019/05/10}{}{%
    \def\pgfutil@translate#1{\translate{#1}}%
    % Correct the wrong definition in `pgfutil-latex.def' 
  }%
  \input{tikz-kaligned-translation.clo}
  \usetikzlibrary{calendar}
}

\AtBeginDocument{%
  \definecolor{dark}{HTML}{A57C00}
  \colorlet{medium}{dark!35}
  \colorlet{bright}{dark!20}
  \colorlet{period}{gray!30}
  \PH@calwidth=\ifPH@print\paperheight\else\paperwidth\fi
  \PH@calheight=\ifPH@print\paperwidth\else\paperheight\fi 
  \@tempcnta=\PH@calwidth
  \divide\@tempcnta by \@M %
  \PH@xunit=\@tempcnta sp %                  0.0845pt (a4)
  \@tempcnta=\PH@calheight
  \divide\@tempcnta by \@M %
  \PH@yunit=\@tempcnta sp %                 0.05974pt (a4)
  \PH@daywidth=693\PH@xunit%                    45mm (a4)
  \PH@daysep=118\PH@xunit   %                   3.5mm (a4)
  \PH@dayheight=162\PH@xunit%                   5.7mm (a4)
  \PH@setFont{PH@dayFont}{134}%                   8pt (a4)     
  \PH@setFont{PH@dayNbFont}{160}%                10pt (a4)
  \PH@setFont{PH@eventFont}{70}%                 8pt (a4)
  \PH@setFont[\normalfont]{PH@normalFont}{160}%  10pt (a4)
  \PH@setFont{PH@weekNbFont}{134}%                8pt (a4)
  \PH@setFont[\bfseries]{PH@monthFont}{160}%     10pt (a4)
  \PH@setFont[\bfseries]{PH@titleFont}{666}%     40pt (a4)
  \PH@setFont[\bfseries]{PH@yearFont}{1000}%     60pt (a4)
  \PH@normalFont
  \ifPH@showweekdays
    \settowidth\@tempdima{\PH@formatDayNb{99}\PH@formatDay{0}}%
  \else
    \settowidth\@tempdima{\PH@formatDayNb{99}}%
  \fi
  \PH@eventwidthL=\dimexpr\PH@daywidth-\@tempdima
  %weeknumbers are now expected to be in the background only. S=L
  \PH@eventwidthS=\dimexpr\PH@eventwidthL
}

\pgfkeys{%
  /PH/.is family, /PH,
  period/.cd,
  color/.estore in=\PH@periodColor,
  name/.estore in=\PH@period@name
}
\pgfkeys{%
  /PH/.is family, /PH,
  event/.cd,
  color/.estore in = \PH@eventColor,
  bgcolor/.estore in = \PH@eventBGColor
}

\newcommand\PH@formatTitle[3]{%
  \raisebox{-.3\height}{\parbox[b]{#1}{%
    \color{\PH@titleColor}%
    \makebox[0pt][l]{\PH@yearFont#2}\hfill
    \PH@titleFont#3\hfill\mbox{}%
  }}%
}
\newcommand*\PH@formatDayNb[1]{%
  \PH@dayNbFont#1\hspace{50\PH@xunit}%
}
\newcommand*\PH@formatDay[1]{%
  \PH@dayFont\pgfcalendarweekdayshortname{#1}%
}
\newcommand*\PH@formatWeekNb[1]{%
  \makebox(0,0){\raisebox{1.4ex}{\hspace{16ex}\PH@weekNbFont\color{\PH@weekNbColor}\arabic{#1}}}%
}
\newcommand*\PH@formatEvent[2]{%
  \PH@eventFont
  \def\PH@tempa{\strut#2}%
  \settowidth\@tempdima{\mbox{\PH@tempa}}%
  \ifdim\@tempdima>#1 %
    \@tempdimb=\dimexpr\f@size pt %
    \@tempdimb=.8\@tempdimb%
    \def\PH@tempa{\fontsize{\@tempdimb}{1.1\@tempdimb}\selectfont#2}%
  \fi
  \makebox[-50\PH@xunit][r]{\raisebox{0.55\totalheight}[\totalheight]{%
    \parbox[c]{#1}{\raggedleft\hskip\z@\PH@tempa}}}% \nointerlineskip 
}

\newcommand*\PH@setFont[3][]{%
  \@tempdima=#3\PH@yunit \@tempdimb=1.2\@tempdima %
  \expandafter\protected@edef\csname#2\endcsname{\noexpand\fontsize
    {\the\@tempdima}{\the\@tempdimb}#1\csname#2\endcsname\noexpand\selectfont}%
} 

\newcommand*\period[2]{%
  \@ifnextchar[{\PH@period@i{#1}{#2}}{\PH@period@i{#1}{#2}[]}%
}
\newcommand*\PH@period@i{}
\def\PH@period@i#1#2[#3]{%
  \begingroup
  \pgfkeys{/PH/period/.cd, #3}%
  \edef\@tempa{%
    \noexpand\ifdate{between=#1 and #2}{%
      \noexpand\tikzset{every day/.style={fill=\PH@periodColor}}}{}%
  }%
  \expandafter\g@addto@macro\expandafter\PH@periods\expandafter{\@tempa}%
  \ifx\PH@period@name\@empty\else
    \pgfcalendar{}{#1}{#2}{%
      \edef\PH@tempa{\pgfcalendarcurrentyear-\pgfcalendarcurrentmonth-%
        \pgfcalendarcurrentday}%
      \let\PH@event@ii=\PH@event@ii@orig% activate temporarily 
      % period name as event entry for event-less days
      \event{\PH@tempa}{\PH@period@name}%
    }%
  \fi
  \endgroup
}

\newcommand*\event{%
  \ClassError{tikz-kaligned}{%
    Macro \string\event\space is only allowed inside of .events files}{}%
}

\newcommand*\PH@event{%
  \@ifstar{\@tempswatrue\PH@event@i}{\@tempswafalse\PH@event@i}%
}
\newcommand*\PH@event@i[2]{%
  \@ifnextchar[{\PH@event@ii{#1}{#2}}{\PH@event@ii{#1}{#2}[]}%
}

\newcommand*\PH@event@ii{}%
\def\PH@event@ii#1#2[#3]{%
  \begingroup
  \pgfkeys{/PH/event/.cd, #3}%
  \@tempdima=\PH@eventwidthL
  \ifPH@showweeknumbers
    \pgfcalendarifdate{#1}{Monday}{\@tempdima=\PH@eventwidthS}{}%
  \fi
  \@ifundefined{event@#1}{%
    \expandafter\protected@xdef\csname event@#1\endcsname{\mbox{\color{\PH@eventColor}#2}}%
    \protected@edef\@tempa{\noexpand\@ifundefined{pgf@sh@ns@cal-#1}{}{%
        \noexpand\node[anchor=south west,inner sep=0pt] at (cal-#1.south east){%
        \noexpand\PH@formatEvent{\the\@tempdima}{%
          \noexpand\csname event@#1\endcsname}};%
      }
    }%
    \expandafter\g@addto@macro\expandafter\PH@events@I\expandafter{\@tempa}%
  }{%
    \expandafter\protected@xdef\csname event@#1\endcsname{%
      \mbox{\color{\PH@eventColor}#2}, \csname event@#1\endcsname}%
  }  
  \if@tempswa
    \edef\@tempa{%
      \noexpand\ifdate{equals=#1}{\noexpand\tikzset{%
        every day/.style={fill=\PH@eventBGColor}}}{}%
    }%
    \expandafter\g@addto@macro\expandafter\PH@backgrounds\expandafter{\@tempa}%
  \fi
  \endgroup 
}

\let\PH@event@ii@orig=\PH@event@ii

\newcommand\PH@makeKalender[2]{%
  \sbox\PH@tempbox{%
    \begin{tikzpicture}[every day/.style={anchor=north}]%
      \calendar[dates=#1 to #2,name=cal,day text={\%d=},%day yshift=3em,%  ????
        day code={%
          \node[name=\pgfcalendarsuggestedname,every day,%
          shape=rectangle,minimum height=\PH@dayheight,%
          text width=\PH@daywidth,draw=black
          ]{\PH@formatDayNb{\tikzdaytext}%
		    \ifPH@showweekdays
              \PH@formatDay{\pgfcalendarcurrentweekday}%
			\fi
            \ifPH@showweeknumbers
              \ifdate{Monday}{\stepcounter{weeknumber}%
                \PH@formatWeekNb{weeknumber}}{}%
            \fi};
        },%
        execute before day scope={%
          \ifdate{day of month=1}{%
		    \setcounter{offsetFirstday}{\pgfcalendarcurrentweekday}
            \pgftransformxshift{\dimexpr\PH@daywidth+\PH@daysep}%
            % Print month name
            \draw (0,0)node [shape=rectangle,minimum height=\PH@dayheight,%
              text width=\PH@daywidth,fill=\PH@monthBGcolor,%
              draw=\PH@monthBGcolor,text=\PH@monthColor,text centered,%
			  anchor=base, yshift=-\pgfcalendarcurrentweekday\PH@dayheight]{%
              \PH@monthFont\pgfcalendarmonthshortname{\pgfcalendarcurrentmonth}};
          }{}%
          \ifdate{workday}{\tikzset{every day/.style=%
            {fill=\PH@workdayBGColor,text=\PH@workdayColor}}}{}%
          %\PH@periods
          \ifdate{Saturday}{\tikzset{every day/.style=%
            {fill=\PH@saturdayBGColor,text=\PH@saturdayColor}}}{}%
          \ifdate{Sunday}{\tikzset{every day/.style=%
            {fill=\PH@sundayBGColor,text=\PH@sundayColor}}}{}%
          \PH@backgrounds
          \PH@periods
          %\PH@backgrounds
        },%
        execute at begin day scope={%
          \pgftransformyshift{-\value{offsetFirstday}\PH@dayheight-\pgfcalendarcurrentday\PH@dayheight}%
        }%
      ];%
      \PH@events@I%
    \end{tikzpicture}%
  }%
  \parbox[c][\PH@calheight]{\PH@calwidth}{%
    \centering
	\ifPH@showtitle
		\vfill
		\PH@formatTitle{\wd\PH@tempbox}{\PH@yearText}{\PH@title}%
		\vfill
	\else
		\vspace{0.02\paperheight}
	\fi
    \usebox\PH@tempbox
    \vfill
	\vspace{2cm}
  }%
}

\newcommand*\makeKalender{%
  \pgfcalendarifdate{\PH@year-01-01}{Tuesday,Wednesday,Thursday}{%
    \setcounter{weeknumber}{1}}{\setcounter{weeknumber}{0}}%
  \begingroup%
    \let\event=\PH@event
    \let\year=\PH@year
    \def\PH@event@ii##1##2[##3]{}% 1st loop: only the periods 
    \def\do##1{\InputIfFileExists{##1.events}{}{}}%
    \expandafter\docsvlist\expandafter{\PH@events@files}%
  \endgroup
  \begingroup
    \let\event=\PH@event
    \let\year=\PH@year
    \def\PH@period@i##1##2[##3]{}% 2nd loop: only the events 
    \def\do##1{\InputIfFileExists{##1.events}{}{}}%
    \expandafter\docsvlist\expandafter{\PH@events@files}%
  \endgroup
  \sbox{\PH@pageI}{\PH@makeKalender{\PH@year-01-01}{\PH@year-12-31}}%
  \ifPH@print
    \rotatebox[origin=c]{90}{\usebox\PH@pageI}%
  \else
    \usebox\PH@pageI
  \fi
}

\setlength\parindent{0pt}
\pagestyle{empty}

\endinput
%%
%% End of file `tikz-kaligned.cls'.




