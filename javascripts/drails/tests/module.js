dojo.provide("drails.tests.module");

try{
  doh.registerUrl("drails.tests.PeriodicalExecuter", dojo.moduleUrl("drails", "tests/PeriodicalExecuter.html"));
  doh.registerUrl("drails.tests.EventObserver", dojo.moduleUrl("drails", "tests/EventObserver.html"));
  doh.registerUrl("drails.tests.Form.Element.EventObserver", dojo.moduleUrl("drails", "tests/Form.Element.EventObserver.html"));
  doh.registerUrl("drails.tests.Form.Observer", dojo.moduleUrl("drails", "tests/Form.Observer.html"));
  doh.registerUrl("drails.tests.Form.Element.Observer", dojo.moduleUrl("drails", "tests/Form.Element.Observer.html"));
  doh.registerUrl("drails.tests.TimedObserver", dojo.moduleUrl("drails", "tests/TimedObserver.html"));
  doh.registerUrl("drails.tests.Observer", dojo.moduleUrl("drails", "tests/Observer.html"));
  doh.registerUrl("drails.tests.Updater", dojo.moduleUrl("drails", "tests/Updater.html"));
  doh.registerUrl("drails.tests.Request", dojo.moduleUrl("drails", "tests/Request.html"));
}catch(e){
  doh.debug(e);
}
