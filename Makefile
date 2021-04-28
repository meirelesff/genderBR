.PHONY: checks runreadme runtests

checks:
	Rscript -e "devtools::document()"
	Rscript -e "devtools::load_all()"
	Rscript -e "devtools::check()"

runreadme:
	Rscript -e "devtools::build_readme()"

runtests:
	Rscript -e "devtools::test()"
