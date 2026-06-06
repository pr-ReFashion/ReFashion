.PHONY: apk
apk:
	@echo "Cleaning project..."
	@flutter clean
	@echo "Creating apk for prod..."
	@flutter build apk --release

.PHONY: ios
ios :
	@echo "Cleaning project..."
	@flutter clean
	@echo "Creating apk for ios...."
	@flutter build ios

.PHONY: aab
aab:
	@echo "Cleaning project..."
	@flutter clean
	@echo "Creating appbundle file..."
	@flutter build appbundle


.PHONY: get
get:
	@echo "Cleaning project..."
	@flutter clean
	@echo "Running pub get..."
	@flutter pub get

.PHONY: runner
runner:
	@flutter packages pub run build_runner build

.PHONY: conflict
conflict:
	@flutter packages pub run build_runner build --delete-conflicting-outputs

.PHONY: git
git:
ifndef m
	$(error Commit message is required. Use 'make git m="your message"')
else
	@echo "=== Running 'git' command ==="
	@git add .
	@echo "Added changes to staging area"
	@git commit -m "$(m)"
	@echo "Committed changes"
	@git push
	@echo "Pushed changes to remote repository"
	@git status
	@echo "=== 'git' command completed ==="
endif
