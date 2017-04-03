/**
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.tomitribe.beryllium.rest;

import com.jayway.jsonpath.JsonPath;
import com.jayway.restassured.filter.log.RequestLoggingFilter;
import com.jayway.restassured.filter.log.ResponseLoggingFilter;
import com.jayway.restassured.response.ValidatableResponse;
import com.jayway.restassured.specification.RequestSpecification;

import net.javacrumbs.jsonunit.core.Option;

import org.jboss.arquillian.test.api.ArquillianResource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.event.Level;
import org.tomitribe.beryllium.Utility;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.List;

import cucumber.api.DataTable;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import org.tomitribe.beryllium.internal.logging.LoggerPrintStream;

import static com.google.common.truth.Truth.assertThat;
import static com.jayway.restassured.RestAssured.given;
import static net.javacrumbs.jsonunit.fluent.JsonFluentAssert.assertThatJson;

public class RestSteps {

    private static Logger LOGGER = LoggerFactory.getLogger(RestSteps.class);

    private ValidatableResponse   response;
    private String                responseValue;
    private LoggerPrintStream     loggerPrintStream = new LoggerPrintStream(LOGGER, Level.DEBUG);
    private RequestLoggingFilter  requestLoggingFilter = new RequestLoggingFilter(loggerPrintStream);
    private ResponseLoggingFilter responseLoggingFilter = new ResponseLoggingFilter(loggerPrintStream);

    @ArquillianResource
    private URL arquillianUrl;

    private RequestSpecification create() {
        return given()
            .filters(requestLoggingFilter, responseLoggingFilter)
            .baseUri(arquillianUrl.toString());
    }

    @When("^I make a (GET|HEAD) call to \"(.*?)\" endpoint$")
    public final void iMakeAGetHeadCallToEndpoint(final String method, final String endpointUrl)
            throws Throwable {
        execute(create(), method, endpointUrl);
    }

    private void execute(final RequestSpecification spec,
                         final String method,
                         final String endpointUrl) throws Exception {
        this.response =
                ("GET".equals(method)) ? spec.get(endpointUrl).then() : spec.head(endpointUrl).then();
        this.responseValue = this.response.extract().body().asString();
    }

    @When("^I make a (POST|PUT) call to \"(.*?)\" endpoint with post body:$")
    public final void iMakeAPostPutCallToEndpointWithPostBody(String method,
                                                              String endpointUrl,
                                                              final String postBody) throws Throwable {
        this.response =
                (method.equals("POST")) ? create()
                        .post(endpointUrl).then() : create()
                        .put(endpointUrl).then();
        this.responseValue = this.response.extract().body().asString();
    }

    @When("^I make a (POST|PUT) call to \"(.*?)\" endpoint with post body in file \"(.*?)\"$")
    public final void iMakeAPostPutCallToEndpointWithPostBodyInFile(final String method,
                                                                    final String endpointUrl,
                                                                    final String postBodyFilePath) throws Throwable {
        iMakeAPostPutCallToEndpointWithPostBody(method, endpointUrl,
                                                Utility.fileContent(postBodyFilePath));
    }

    @When("^I make a DELETE call to \"(.*?)\" endpoint$")
    public final void iMakeADeleteCallToEndpoint(final String endpointUrl) throws Throwable {
        this.response = create().delete(endpointUrl).then();
        this.responseValue = this.response.extract().body().asString();
    }

    @When("^I make a (GET|HEAD) call to \"(.*?)\" endpoint with headers:$")
    public void iMakeAGetHeadCallToEndpointWithHeaders(final String method,
                                                       final String endpointUrl,
                                                       final DataTable headers) throws Throwable {
        final RequestSpecification spec = create()
                .headers(headers.asMap(String.class, String.class));
        execute(spec, method, endpointUrl);
    }

    @When("^I make a (GET|HEAD) call to \"(.*?)\" endpoint with query params:$")
    public void iMakeAGetHeadCallToEndpointWithQueryParams(final String method,
                                                           final String endpointUrl,
                                                           final DataTable params) throws Throwable {
        final RequestSpecification spec = create()
                .params(params.asMap(String.class, String.class));
        execute(spec, method, endpointUrl);
    }

    @When("^I make a (POST|PUT) call to \"(.*?)\" endpoint with post body in file \"(.*?)\" and headers:$")
    public void iMakeAPostPutCallToEndpointWithPostBodyInFileAndHeaders(
            final String method, final String endpointUrl, final String postBodyFilePath,
            final DataTable headers) throws IOException, URISyntaxException {
        final RequestSpecification spec =
                create().headers(headers.asMap(String.class, String.class)).body(
                        Utility.fileContent(postBodyFilePath));
        this.response = (method.equals("POST")) ? spec.post(endpointUrl).then() : spec.put(endpointUrl).then();
        this.responseValue = this.response.extract().body().asString();
    }

    @Then("^response status code should be (\\d+)$")
    public final void responseStatusCodeShouldBe(final int statusCode) throws Throwable {
        assertThat(this.response.extract().statusCode()).isEqualTo(statusCode);
    }

    @Then("^response content type should be \"(.*?)\"$")
    public final void responseContentTypeShouldBe(final String contentType) throws Throwable {
        assertThat(this.response.extract().contentType()).isEqualTo(contentType);
    }

    @Then("^response should be json in file \"(.*?)\"$")
    public final void responseShouldBeJsonResponseBody(final String contentFilePath)
            throws Throwable {
        this.responseShouldBeJson(Utility.fileContent(contentFilePath));
    }

    @Then("^response should be json in file \"(.*?)\" ignoring array order$")
    public final void responseShouldBeJsonIgnoringArrayOdersResponseBody(
            final String contentFilePath) throws Throwable {
        final String content = Utility.fileContent(contentFilePath);
        this.responseShouldBeJsonIgnoringArrayOrder(content);
    }

    @Then("^response should be json:$")
    public final void responseShouldBeJson(final String jsonResponseString) throws Throwable {
        assertThatJson(this.responseValue).ignoring("${json-unit.ignore}")
                                          .isEqualTo(jsonResponseString);
    }

    @Then("^response should be json ignoring array order:$")
    public final void responseShouldBeJsonIgnoringArrayOrder(final String jsonResponseString)
            throws Throwable {
        assertThatJson(this.responseValue).ignoring("${json-unit.ignore}")
                                          .when(Option.IGNORING_ARRAY_ORDER).isEqualTo(jsonResponseString);
    }

    @Then("^response should be empty$")
    public final void responseShouldBeEmpty() throws Throwable {
        assertThat(this.responseValue).isEmpty();
    }

    @Then("^response should be:$")
    public final void responseShouldBe(final String contentFile) throws Throwable {
        assertThat(this.responseValue).isEqualTo(contentFile);
    }

    @Then("^response should be file \"(.*?)\"$")
    public final void responseShouldBeFile(final String contentFilePath) throws Throwable {
        this.responseShouldBe(Utility.fileContent(contentFilePath));
    }

    @Then("^response header \"(.*?)\" should be \"(.*?)\"$")
    public final void responseHeaderShouldBe(final String responseHeaderName,
                                             final String headerValue) throws Throwable {
        assertThat(this.response.extract().header(responseHeaderName)).isEqualTo(headerValue);
    }

    @Then("^response json path list \"(.*?)\" should be:$")
    public void responseJsonPathListShouldBe(final String jsonPath, final DataTable list)
            throws Throwable {
        final List<String> responseList = JsonPath.read(this.responseValue, jsonPath);
        assertThat(responseList).isEqualTo(list.asList(String.class));
    }

    @Then("^response json path element \"(.*?)\" should be \"(.*?)\"$")
    public void responseJsonPathElementShouldBe(final String jsonPath, final String value)
            throws Throwable {
        final Object responseValue = JsonPath.read(this.responseValue, jsonPath);
        assertThat(String.valueOf(responseValue)).isEqualTo(value);
    }

    @Then("^response json path list \"(.*?)\" should be of length (\\d+)$")
    public void responseJsonPathListShouldBeOfLength(final String jsonPath, final int length) {
        final List<Object> responseList = JsonPath.read(this.responseValue, jsonPath);
        assertThat(responseList.size()).isEqualTo(length);
    }

    @Then("^response json path list \"(.*?)\" should be at least of length (\\d+)$")
    public void responseJsonPathListShouldBeAtLeastOfLength(final String jsonPath,
                                                            final int length) {
        final List<Object> responseList = JsonPath.read(this.responseValue, jsonPath);
        assertThat(responseList.size()).isAtLeast(length);
    }
}
