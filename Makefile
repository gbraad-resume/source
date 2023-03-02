CONTAINER_RUNTIME ?= podman

.PHONY: resume
resume:
	${CONTAINER_RUNTIME} pull ghcr.io/gbraad/docugen:latest
	git clone https://gitlab.com/gbraad/document-generation-assets.git assets --depth 1
	mkdir public
	${CONTAINER_RUNTIME} run --rm -v ${PWD}:/workspace ghcr.io/gbraad/docugen:latest pandoc -t html5 -f markdown-citations --template assets/templates/resume-template.html --standalone --section-divs -o ./public/index.html ./index.md
	${CONTAINER_RUNTIME} run --rm -v ${PWD}:/workspace ghcr.io/gbraad/docugen:latest pandoc -t html5 --template ./assets/templates/resume-template.html --standalone --section-divs -o ./public/resume.html ./resume.md
	${CONTAINER_RUNTIME} run --rm -v ${PWD}:/workspace ghcr.io/gbraad/docugen:latest pandoc -t html5 --template ./assets/templates/resume-template.html --standalone --section-divs -o ./public/recommendations.html ./recommendations.md
	cp ./gbraad-fc.png ./public/
	${CONTAINER_RUNTIME} pull ghcr.io/gbraad/phantomjs:latest
	${CONTAINER_RUNTIME} run --rm -v ${PWD}:/workspace ghcr.io/gbraad/phantomjs:latest ./assets/scripts/topdf.js ./public/resume.html ./public/resume.pdf 0.7
	${CONTAINER_RUNTIME} run --rm -v ${PWD}:/workspace ghcr.io/gbraad/phantomjs:latest ./assets/scripts/topdf.js ./public/resume.html ./public/resume-A5.pdf 0.7 A5
	${CONTAINER_RUNTIME} run --rm -v ${PWD}:/workspace ghcr.io/gbraad/phantomjs:latest ./assets/scripts/topdf.js ./public/recommendations.html ./public/recommendations.pdf 0.7