vector<string> read_file(string filename)
	{
	vector<std::string> lines;
	string line;


	ifstream ifile (filename.c_str());
	if (ifile.is_open())
		{
	    	while ( ifile.good() )
	    		{
	     	 	getline (ifile,line);
			// To avoid the zero length lines that it's reading (don't know why)
			if ( line.length() > 0 )
				{
				line.erase(line.find_last_not_of(" \n\r\t")+1);
	  			lines.push_back(line);
				}
	    		}
	    	ifile.close();
	  	}

	else 
		reporter->InternalError("Cannot open file"); 
	return lines;	
	}
