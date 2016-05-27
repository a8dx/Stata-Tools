
/*
Author: Anthony D'Agostino (ald2187 [at] columbia.edu)
Filename: esttab_Latex_Sample.do 
Date Created: 05/27/2016
Dataset: 
Purpose: 


*/ 


cap program drop sampleRun
		program define sampleRun
			syntax, dv(string) [subsetDescription(string)] 
	/* 
	dv: dependent variable. 
	subsetDescription: enters into header. 
	*/ 
	
	eststo clear
	set more off 
	
	loc full_controls "i.control1 control2 control3 c.control4##c.control4" 		
	loc notes "Controls include ."	
		loc lbl: variable label `dv'
	
	

	
		qui eststo: reg `dv' ib0.var1##c.var2 [pweight = weight], vce(cluster vill_state_98)
					su `dv' if e(sample), mean 
							loc mymean: di %8.2f r(mean) 	
								estadd loc mD `mymean', replace							
								estadd loc statefe "", replace 	
								
		qui eststo: reg `dv' `full_controls' ib0.var1##c.var2 [pweight = weight], vce(cluster vill_state_98)
					su `dv' if e(sample), mean 
							loc mymean: di %8.2f r(mean) 	
								estadd loc mD `mymean', replace							
								estadd loc statefe "", replace 	
								estadd loc controls "$\checkmark$", replace	

		qui eststo: reg `dv' `full_controls' i.state ib0.var1##c.var2 [pweight = weight], vce(cluster vill_state_98)
					su `dv' if e(sample), mean 
							loc mymean: di %8.2f r(mean) 	
								estadd loc mD `mymean', replace							
								estadd loc statefe "$\checkmark$", replace 	
								estadd loc controls "$\checkmark$", replace								
								
		qui eststo: reg `dv' ib0.var1##c.var2 if `dv' > 0 [pweight = weight], vce(cluster vill_state_98)
					su `dv' if e(sample), mean 
							loc mymean: di %8.2f r(mean) 	
								estadd loc mD `mymean', replace 							
								estadd loc statefe "", replace 	
								
		qui eststo: reg `dv' `full_controls' ib0.var1##c.var2 if `dv' > 0 [pweight = weight], vce(cluster vill_state_98)
					su `dv' if e(sample), mean 
							loc mymean: di %8.2f r(mean) 	
								estadd loc mD `mymean', replace 							
								estadd loc statefe "", replace 	
								estadd loc controls "$\checkmark$", replace	
								
		qui eststo: reg `dv' `full_controls' i.state ib0.var1##c.var2 if `dv' > 0 [pweight = weight], vce(cluster vill_state_98)
					su `dv' if e(sample), mean 
							loc mymean: di %8.2f r(mean) 	
								estadd loc mD `mymean', replace							
								estadd loc statefe "$\checkmark$", replace 	
								estadd loc controls "$\checkmark$", replace									

								
								

	loc dv_no_us = subinstr("`dv'", "_", "", . ) 
	
	#delimit ; 
	loc heading "<insert table header here> `subsetDescription'"; 
 	loc odir "<insert path here>";
		cap mkdir "`odir'";
	loc ofile "`odir'/<insert filename here>.tex"; 

	
	loc resize 1.0; 
			esttab using "`ofile'", se r2 label compress replace obslast depvars nocons nomtitles nonum
			keep(1.var1 var2 1.var1#c.var2) legend star(* 0.10 ** 0.05 *** 0.01) title("`heading'") varlabels(1.var1 "Variable 1" var2 "Variable 2" 1.var1#c.var2 "Variable 1 $\times\$ Variable 2") 
			s(N mD controls statefe r2_a, labels("N" "DV Mean" "Controls" "State FE" "Adj. R$^2$")) 
			prehead(
				\begin{table}[!htbp] 
				\centering 
				\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
				\label{tab:LFPR`dv_no_us'}
				\caption{`heading'}  
				\resizebox{`resize'\textwidth}{!}{
				\begin{tabular}{l*{@M}{c}}\tabularnewline \hline
				&\multicolumn{3}{c}{Days}&\multicolumn{3}{c}{Days $\times\$ 1(Days$>$0)}\\\cmidrule(l){2-4}\cmidrule(l){5-7} 
				)
				posthead(\hline \hline \)
				prefoot(\hline \noalign{\smallskip})
				postfoot(
				\hline\hline \noalign{\smallskip}
				\end{tabular}
				}
				\medskip
				\begin{minipage}{`resize'\textwidth}
				\footnotesize Notes: "`notes'"  \\ 
				@starlegend 
				\end{minipage}
				\end{table}
				); 	
	#delimit cr 
			
	end 
