# PostgreSQL Dev Container environment

1. Run the `Setup` task

2. Run the `Build` task

3. Run the `Test full` task

4. Run the `Run psql` task

5. Create patch
```sh
git add <changed_files>
git diff --cached > new_feature.patch
```