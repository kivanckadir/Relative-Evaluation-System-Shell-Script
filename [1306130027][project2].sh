if [ $# -eq 1 ];
then
	if [ -f $1 ]; 
	then
		if [ -s $1 ];
		then	
			awk -F "[	]" '
			{
				ssum = $2 + $3
				savg = ssum / 2
				
				if (savg >= 35)
					{
						noes++
						inBDSavg[noes] = savg
						inBDSfin[noes] = $3
						csum = csum + savg
					}


				else 	{
						nofs++
						outBDSavg[nofs] = savg
						outBDSfin[nofs] = $3
					}
			} 	END	{
						cavg = csum / noes
						for(i=1; i<=noes; i++) 
							{
								temp = temp + (1/(noes-1)) * (inBDSavg[i]-cavg) * (inBDSavg[i]-cavg);
							}

						S = sqrt(temp)
						baraj = cavg - (1.645 * S)

						if ( noes < 10 || S < 8 )
							{
								baraj=45
							}
						for(i=1; i<=noes; i++)
							{
								if ( inBDSfin[i] >= 45 && inBDSavg[i] >= baraj)
									{
										noss++
									}

								else 	{
										nofs++
									}
							}
	
						printf "%d students failed and %d students passed in this course.\n", nofs, noss
			      		}' $1
				
		else echo $1 "is empty file!"
		fi
	else echo $1 "was not found!"
	fi
elif [ $# -gt 1 ];
then
	echo "Too many parameters!"

else	echo "Missing parameters!"
fi
