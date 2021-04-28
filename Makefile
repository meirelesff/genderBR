.PHONY: workflow

checagem:
	Rscript -e "devtools::document()"
	Rscript -e "devtools::load_all()"
	Rscript -e "devtools::check()"
