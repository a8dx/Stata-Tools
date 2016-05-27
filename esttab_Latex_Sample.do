
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
	
	loc full_controls "marital i.act_status hhsize edu c.age##c.age i.caste i.hh_rating" 		
	loc notes "Controls include control1 control2 control3 control4 control5$^2$. Add more description here.  Further description.  Much more description.  No problems with column width here.  Can also do math, $\frac{3}{4} \leq \frac{4}{3}$, and more description here."	
		loc lbl: variable label `dv'
	
	

	
		qui eststo: reg `dv' ib0.sex##c.Class1_pct_1km [pweight = weight], vce(cluster vill_state_98)
					su `dv' if e(sample), mean 
							loc mymean: di %8.2f r(mean) 	
								estadd loc mD `mymean', replace							
								estadd loc statefe "", replace 	
								
		qui eststo: reg `dv' `full_controls' ib0.sex##c.Class1_pct_1km [pweight = weight], vce(cluster vill_state_98)
					su `dv' if e(sample), mean 
							loc mymean: di %8.2f r(mean) 	
								estadd loc mD `mymean', replace							
								estadd loc statefe "", replace 	
								estadd loc controls "$\checkmark$", replace	

		qui eststo: reg `dv' `full_controls' i.state_code ib0.sex##c.Class1_pct_1km [pweight = weight], vce(cluster vill_state_98)
					su `dv' if e(sample), mean 
							loc mymean: di %8.2f r(mean) 	
								estadd loc mD `mymean', replace							
								estadd loc statefe "$\checkmark$", replace 	
								estadd loc controls "$\checkmark$", replace								
								
		qui eststo: reg `dv' ib0.sex##c.Class1_pct_1km if `dv' > 0 [pweight = weight], vce(cluster vill_state_98)
					su `dv' if e(sample), mean 
							loc mymean: di %8.2f r(mean) 	
								estadd loc mD `mymean', replace 							
								estadd loc statefe "", replace 	
								
		qui eststo: reg `dv' `full_controls' ib0.sex##c.Class1_pct_1km if `dv' > 0 [pweight = weight], vce(cluster vill_state_98)
					su `dv' if e(sample), mean 
							loc mymean: di %8.2f r(mean) 	
								estadd loc mD `mymean', replace 							
								estadd loc statefe "", replace 	
								estadd loc controls "$\checkmark$", replace	
								
		qui eststo: reg `dv' `full_controls' i.state_code ib0.sex##c.Class1_pct_1km if `dv' > 0 [pweight = weight], vce(cluster vill_state_98)
					su `dv' if e(sample), mean 
							loc mymean: di %8.2f r(mean) 	
								estadd loc mD `mymean', replace							
								estadd loc statefe "$\checkmark$", replace 	
								estadd loc controls "$\checkmark$", replace									

								
								

	loc dv_no_us = subinstr("`dv'", "_", "", . ) 
	
	#delimit ; 
	loc heading "Insert Table Header Here"; 
 	loc odir "$tabBase/1982/timeModels";
		cap mkdir "`odir'";
	loc ofile "`odir'/timeModels_FAKE.tex"; 

	
	loc resize 1.0; 
			esttab using "`ofile'", se r2 label compress replace obslast depvars nocons nomtitles nonum
			keep(1.sex Class1_pct_1km 1.sex#c.Class1_pct_1km) legend star(* 0.10 ** 0.05 *** 0.01) title("`heading'") varlabels(1.sex "Variable 1" Class1_pct_1km "Variable 2" 1.sex#c.Class1_pct_1km "Variable 1 $\times\$ Variable 2") 
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
