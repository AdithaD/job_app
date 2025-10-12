/// <reference path="../pb_data/types.d.ts" />

onRecordCreate((e) => {
  var newJobId = 0;
  try {
    const result = new DynamicModel({
      // describe the shape of the data (used also as initial values)
      jobId: 0,
    });
    $app
      .db()
      .newQuery("SELECT MAX(jobId) AS jobId FROM jobs")
      .one(result);

    newJobId = result.jobId + 1;
  } catch (error) {
    console.log("Nil rows, job id = 0;");
  }

  e.record.set("jobId", newJobId);

  e.next();
});
